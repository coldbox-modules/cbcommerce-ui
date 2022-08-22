/**
 * Global Third-Party Imports
 **/
import Vue from "vue";
import VueTruncate from "vue-truncate-filter";
import VTooltip from "v-tooltip";
import VueCurrencyFilter from "vue-currency-filter";
import VeeValidate from "vee-validate";
import VueScrollTo from "vue-scrollto";
import titleMixin from '@cbCommerce/mixins/title-mixin';
import VueCarousel from 'vue-carousel';
Vue.use(VueCarousel);

/**
 * Vue applications
 */
Vue.use( VeeValidate );
Vue.use( VueTruncate );
Vue.use( VTooltip );
Vue.mixin(titleMixin);


Vue.use(
    VueScrollTo,
    {
        container: "body",
        duration: 500,
        easing: "ease",
        offset: -300,
        force: true,
        cancelable: true,
        onStart: false,
        onDone: false,
        onCancel: false,
        x: false,
        y: true
    }
);

Vue.use(
    VueCurrencyFilter,
    {
        symbol: '$',
        thousandsSeparator: ',',
        fractionCount: 2,
        fractionSeparator: '.',
        symbolPosition: 'front',
        symbolSpacing: false
    }
);

/**
 * Global cbCommerce Vue components
 */
Vue.component( "Checkout", require( "@cbCommerce/components/commerce/checkout" ).default );
Vue.component( "OrderSummary", require( "@cbCommerce/components/commerce/order-summary" ).default );
Vue.component( "NewAccount", require( "@cbCommerce/components/account/new-account" ).default );
Vue.component( "AccountEdit", require( "@cbCommerce/components/account/account-edit" ).default );
Vue.component( "GenericLoader", require( "@cbCommerce/components/generic-loader" ).default );
Vue.component( "NavCart", require( "@cbCommerce/components/ui/nav-cart" ).default );
Vue.component( "NavUser", require( "@cbCommerce/components/ui/nav-user" ).default );
Vue.component( "CategoryGrid", require( "@cbCommerce/components/categories/category-grid" ).default );
Vue.component( "CategoryDetail", require( "@cbCommerce/components/categories/category-detail" ).default );
Vue.component( "WishlistsGrid", require( "@cbCommerce/components/wishlists/wishlists-grid" ).default );
Vue.component( "WishlistsGridItem", require( "@cbCommerce/components/wishlists/wishlists-grid-item" ).default );
Vue.component( "WishlistDetail", require( "@cbCommerce/components/wishlists/wishlist-detail" ).default );
Vue.component( "WishlistItem", require( "@cbCommerce/components/wishlists/wishlist-item" ).default );
Vue.component( "WishlistForm", require( "@cbCommerce/components/wishlists/wishlist-form" ).default );
Vue.component( "WishlistAddIcon", require( "@cbCommerce/components/wishlists/wishlist-add-icon" ).default );
Vue.component( "ComparisonAddIcon", require( "@cbCommerce/components/products/comparison-add-icon" ).default );
Vue.component( "UsedProducts", require( "@cbCommerce/components/products/used-products" ).default );
Vue.component( "ProductFilterPage", require( "@cbCommerce/components/products/product-filter-page" ).default );
Vue.component( "ProductDetail", require( "@cbCommerce/components/products/product-detail" ).default );
Vue.component( "ProductSearch", require( "@cbCommerce/components/products/product-search" ).default );
Vue.component( "SkuQuoteModal", require( "@cbCommerce/components/products/sku-quote-modal" ).default );
Vue.component( "ProductCarousel", require( "@cbCommerce/components/products/product-carousel" ).default );
Vue.component( "ContactForm", require( "@cbCommerce/components/contact-form" ).default );
Vue.component( "ProductComparison", require( "@cbCommerce/components/products/product-comparison" ).default );
Vue.component( "ProductWishlist", require( "@cbCommerce/components/products/product-wishlist" ).default );
Vue.component( "ShoppingCart", require( "@cbCommerce/components/commerce/shopping-cart" ).default );
Vue.component( "CbcommerceNav", require( "@cbCommerce/components/cbcommerce-nav" ).default );
Vue.component( "LoginForm", require( "@cbCommerce/components/login-form" ).default );
