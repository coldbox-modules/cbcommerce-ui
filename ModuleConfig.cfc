component {

    this.name           = "cbcommerce-ui";
    this.title          = "cbCommerce Public UI";
    this.description    = "cbCommerce is the eCommerce Platform for the ContentBox Modular CMS";
    this.version        = "1.0.0";
    this.author         = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl         = "https://github.com/jclausen/cbCommerce";
    this.cfmapping      = "cbcUI";
    this.modelNamespace	= "cbcUI";
    this.viewParentLookup = true;
    this.layoutParentLookup = true;
	this.entryPoint = "store";
    this.dependencies   = [
        "cbi18n"
    ];

	/**
	 * Configure Module
	 */
    function configure() {

        settings = {
			"baseAPIHref" : getSystemSetting( "CBCOMMERCE_ENTRYPOINT", "/cbc/api/v1" ),
			"features" : {
				"consignment" : getSystemSetting( "CBCOMMERCE_ENABLE_CONSIGNMENT", true ),
				"used" : getSystemSetting( "CBCOMMERCE_ENABLE_USED_PRODUCTS", true )
			},
			"displayCategoriesNav" : true,
			"storeName" : "cbCommerce Demo Store"
		};

		cbi18n={
			// Extra resource bundles to load
			resourceBundles = {
				"cbCommerce" : "/cbcUI/includes/i18n/cbCommerce",
				"cbCommerceAdmin" : "/cbcUI/includes/i18n/cbCommerceAdmin",
				"cbCommerceOrders" : "/cbcUI/includes/i18n/cbCommerceOrders"
			}
		}

        // Custom Declared Interceptors
		interceptors = [
			{
					class="cbcUI.interceptors.GlobalData",
					name="CBCGlobalDataInterceptor"
			}
        ];

    }

    function onLoad() {
		var isAPIRegistered = controller.getModuleService().isModuleRegistered( "cbcommerce-api" );
		interceptors.append(
			[
				{
					class="cbcUI.interceptors.CBCMenuHelper",
					name="CBCMenuHelperInterceptor"
				}
			],
			true
		);
		// @TODO: Move to ContentBox module
		var isContentBoxContext = controller.getModuleService().isModuleRegistered( "contentbox" );
		if( isContentBoxContext ){
			// Add our menu item
			var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );

			menuService.addSubMenu(
				topMenu=menuService.MODULES,
				name="cbCommerce",
				label="Store Admin",
				href=menuService.buildModuleLink( 'store', 'admin' )
			);

			/**
			* Overload for ContentBox default Sitemap Routing
			*/
			appRouter.prepend()
						.route( "sitemap" )
						.to( "cbCommerce:Sitemap.index" );
		}

	}

}