component extends="BaseHandler"{

	function index( event, rc, prc ){
		// Setup the Module  Entry Point
		prc.cbCommerceEntryPoint = getModuleConfig( "cbcommerce-ui" ).entryPoint;
		// exit Handlers
		prc.xehShoppingCart = "#prc.cbCommerceEntryPoint#/shopping-cart";

        prc.assetBag.addJavascriptToFooter("https://js.stripe.com/v3/");

        event.setView( "checkout/index" );
    }

    function thankyou( event, rc, prc ){
        event.setView( "checkout/thankyou" );
    }
 }