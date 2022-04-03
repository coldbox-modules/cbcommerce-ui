component{
	function configure(){

            route( "category/used" ).to( "Category.used" );
            route( "category/:id" ).to( "Category.detail" );
            route( "category" ).to( "Category.index" );
            route( "product/comparison" ).to( "Product.comparison" );
            route( "product/:id" ).to( "Product.detail" );
            route( "product" ).to( "Product.index" );
            route( "shopping-cart" ).to( "Cart.index" );
            route( "checkout/login" ).to( "Checkout.login" );
            route( "checkout/thankyou/:id" ).to( "Checkout.thankyou" );
            route( "checkout" ).to( "Checkout.index" );
            route( "wishlist/:id" ).to( "Wishlist.detail" );
            route( "wishlists/new" ).to( "Wishlist.edit" );
            route( "wishlists/edit/:id" ).to( "Wishlist.edit" );
            route( "wishlists/:id" ).to( "Wishlist.detail" );
            route( "wishlists" ).to( "Wishlist.index" );
            route( "account/reset/:token" ).to( "Account.reset" );
            route( "account/edit" ).to( "Account.edit" );
            route( "account/create" ).to( "Account.create" );
            route( "account/login" ).to( "Account.login" );
            route( "account" ).to( "Account.index" );
            route( "sitemap" ).to( "Sitemap.index");

            route( "admin" ).toHandler( "Admin" );

            route( ":action?" )
                .toHandler( "Main" );
	}
}