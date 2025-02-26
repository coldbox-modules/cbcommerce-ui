component{
    // DI
	property name="entryService"		inject="entryService@cb";
	property name="pageService"			inject="pageService@cb";
	property name="contentService"		inject="contentService@cb";
	property name="CBHelper"			inject="CBHelper@cb";
    property name="settingService"		inject="settingService@cb";
    property name="productService"      inject="ProductService@cbCommerce";
    property name="categoryService"     inject="ProductCategoryService@cbCommerce";

	/**
	* Executes before all handler actions
	*/
	any function preHandler( event, rc, prc, action, eventArguments ){
		// params
		param name="rc.format" default="html";
		// Prepare UI Request
		CBHelper.prepareUIRequest( 'pages' );
		// Verify if sitemap is enabled, else, proxy into the page event
		if( !prc.cbSettings.cb_site_sitemap ){
			// proxy
			event.overrideEvent( "contentbox-ui:page.index" );
			return;
		}
	}

	/**
	* Sitemap Wrapper
	*/
	function index( event, rc, prc ){

		// Caching Enabled? Then test if data is in cache.
		var cacheEnabled = (
			!event.valueExists( "cbCache" )
        );

		if( cacheEnabled ){
			// Get appropriate cache provider from settings
			var cache 		= cacheBox.getCache( prc.cbSettings.cb_content_cacheName );
			var cacheKey 	= "cbCommerce-sitemap-#cgi.http_host#" &
				hash( ".#rc.format#.#event.isSSL()#" & prc.cbox_incomingContextHash  );

			// get content data from cache
			var results = cache.get( cacheKey );
			// if NOT null and caching enabled and noCache event argument does not exist and no incoming cbCache URL arg, then cache
			if( !isNull( results ) ){
				// Set cache headers if allowed
				if( prc.cbSettings.cb_content_cachingHeader ){
					event.setHTTPHeader( name="x-contentbox-cached-content", value="true" );
				}
				// return cache content to be displayed
				event.renderData(
					data 		= results.data,
					contentType = results.contentType,
					statusCode 	= prc.cbSettings.cb_content_cachingHeader ? 203 : 200
				);
				return;
			}
		}

		// Execute sitemap
		var results = _index( argumentCollection=arguments );

		// verify if caching is possible by testing the content parameters
		if( cacheEnabled ){
			// Cache data
			cache.set(
				cachekey,
				results,
				( prc.cbSettings.cb_content_cachingTimeout ),
				( prc.cbSettings.cb_content_cachingTimeoutIdle )
			);
		}

		// Render it out
		event.renderData(
			data		= results.data,
			contentType	= results.contentType
		);
	}

	/**
	* Single entry point, outputs the sitemap according to the incoming `rc.format`
	* @return { data, contentType }
	*/
	private struct function _index( event, rc, prc ){
		// store UI module root
		prc.cbRoot 			= getContextRoot() & event.getModuleRoot( 'contentbox' );
		// store module entry point
		prc.cbEntryPoint	= getModuleConfig( "contentbox-ui" ).entryPoint;

		// Several Link Defs
		prc.linkHome 	= CBHelper.linkHome();
		prc.siteBaseURL = CBHelper.siteBaseURL();
		prc.disableBlog = settingService.getSetting( 'cb_site_disable_blog' );

		// Get Content Data
		prc.aPages = pageService.getAllFlatPages(
			sortOrder		= "order asc",
			isPublished 	= true,
			showInSearch 	= true
		);

		// Blog data if enabled
		if( prc.disableBlog == false ){
			prc.blogEntryPoint = settingService.getSetting( 'cb_site_blog_entrypoint' );
			if( len( prc.blogEntryPoint ) && right( prc.blogEntryPoint, 1) != '/' ){
				prc.blogEntryPoint = prc.blogEntryPoint & '/';
			}
			// Entry Content
			prc.aEntries = entryService.getAllFlatEntries(
				sortOrder		= "createdDate asc",
				isPublished 	= true,
				showInSearch 	= true
			);
		}

		// we are doing this in a query, for speed, because we only need three fields
		var sql = "
			SELECT id, modifiedTime,
			( SELECT FK_media FROM cbc_productMedia WHERE FK_product = products.id ORDER BY isPrimary DESC, displayOrder ASC, createdTime ASC LIMIT 1 ) as mediaId
			FROM cbc_products products
			WHERE products.isActive = 1
			AND EXISTS (
				SELECT FK_product FROM cbc_SKUs  WHERE FK_product = products.id AND isActive = 1
			)
			ORDER BY products.name ASC
		";
		var qProducts = new query( sql = sql );
		prc.siteMapProducts = qProducts.execute().getResult();

		var sql = "
			SELECT id, modifiedTime,
			( SELECT FK_media FROM cbc_productCategoryMedia WHERE FK_category = categories.id ORDER BY isPrimary DESC, displayOrder ASC, createdTime ASC LIMIT 1 ) as mediaId
			FROM cbc_productCategories categories
			WHERE categories.isActive = 1
			AND categories.id IN (
				SELECT FK_category from cbc_lookups_products_categories WHERE FK_product IN
				(
					SELECT id FROM cbc_products products
					WHERE products.isActive = 1
					AND EXISTS (
						SELECT FK_product FROM cbc_SKUs WHERE FK_product = products.id AND isActive = 1
					)
				)
			)
			ORDER BY categories.name ASC
		";
		var qCategories = new query( sql = sql );
		prc.siteMapCategories = qCategories.execute().getResult();

		// Render it out in specific format
		switch( rc.format ){
			case "xml" : {
				return {
					data 		= renderView( view="sitemap/xml", module="cbcommerce-ui" ),
					contentType = "application/xml"
				};
			}
			case "json" : {
				return {
	  				data 		= renderView( view="sitemap/json", module="cbcommerce-ui" ),
	  				contentType = "application/json"
				};
			}
			case "txt" : {
				return {
	  				data 		= renderView( view="sitemap/txt", module="cbcommerce-ui" ),
	  				contentType = "text/plain"
				};
			}
			default : {
				event.setView( "sitemap_html" );
				return {
	  				data = renderLayout(
	  					module		= event.getCurrentLayoutModule(),
	  					viewModule	= event.getCurrentViewModule()
	  				),
	  				contentType = "text/html"
				};
			}
		}
	}
}