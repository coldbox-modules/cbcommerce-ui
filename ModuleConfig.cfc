component {

    this.name           = "cbCommerce";
    this.title          = "cbCommerce";
    this.description    = "cbCommerce is the eCommerce Platform for the ContentBox Modular CMS";
    this.version        = "1.0.0-alpha1";
    this.author         = "Jon Clausen <jclausen@ortussolutions.com>";
    this.webUrl         = "https://github.com/jclausen/cbCommerce";
    this.cfmapping      = "cbcUi";
    this.modelNamespace	= "cbcUi";
    this.entryPoint     = "store";
    this.viewParentLookup = true;
    this.layoutParentLookup = true;
    this.dependencies   = [
        "cbCommerce",
        "cbi18n"
    ];

	/**
	 * Configure Module
	 */
    function configure() {
		if( len( getSystemSetting( "CBCOMMERCE_ENTRYPOINT", "" ) ) ){
			this.entryPoint = getSystemSetting( "CBCOMMERCE_ENTRYPOINT" );
		}

        settings = {};

        // Custom Declared Interceptors
		interceptors = [
			{
					class="cbCommerce.interceptors.GlobalData",
					name="GlobalDataInterceptor"
			}
        ];

    }

    function onLoad() {
		var isContentBoxContext = controller.getModuleService().isModuleRegistered( "contentbox" );
		if( !isContentBoxContext ){
			interceptors.append(
				[
					{
						class="cbCommerce.interceptors.CBCMenuHelper",
						name="CBCMenuHelperInterceptor"
					}
				],
				true
			);
			// Add our menu item
			var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );

			menuService.addSubMenu(
				topMenu=menuService.MODULES,
				name="cbCommerce",
				label="Store Admin",
				href=menuService.buildModuleLink( 'store', 'admin' )
			);
		}
        /**
        * Overload for ContentBox default Sitemap Routing
        */
        appRouter.prepend()
                    .route( "sitemap" )
                    .to( "cbCommerce:Sitemap.index" );

		moduleSettings = {
			"cbi18n" : {
				// Extra resource bundles to load
				resourceBundles = {
					"cbCommerce" : "/cbcUi/includes/i18n/cbCommerce",
					"cbCommerceAdmin" : "/cbcUi/includes/i18n/cbCommerceAdmin",
					"cbCommerceOrders" : "/cbcUi/includes/i18n/cbCommerceOrders"
				}
			}
		};

	}

}