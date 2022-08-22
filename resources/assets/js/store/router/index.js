import CategoryGrid from "@cbCommerce/components/categories/category-grid";
import ProductFilterPage from "@cbCommerce/components/products/product-filter-page";
import ProductDetail from "@cbCommerce/components/products/product-detail";
import ContactForm from "@cbCommerce/components/contact-form";
import ProductComparison from "@cbCommerce/components/products/product-comparison";
import WishlistsGrid from "@cbCommerce/components/wishlists/wishlists-grid";
import ShoppingCart from "@cbCommerce/components/commerce/shopping-cart";
import Storefront from "@cbCommerce/components/storefront";
import Vue from "vue";

export const createRouter = (Vue, Router) => {
	Vue.use(Router);
	return new Router({
		mode: "history",
		routes: [
			{
				path: "/store",
				component: Storefront,
				children: [
					{
						path: "product/:id",
						component: ProductDetail,
						name: "product"
					},
					{
						path: "cart",
						component: ShoppingCart,
						name: "cart"
					},
					{
						path: "compare",
						component: ProductComparison,
						name: "comparison"
					},
					{
						path: "search",
						component: ProductFilterPage,
						name: "search"
					},
					{
						path: "wishlist",
						component: WishlistsGrid,
						name: "wishlist"
					},
					{
						path: "categories/:id",
						component: CategoryGrid,
						name: "category"
					},
					{
						path: "support/contact",
						component : ContactForm,
						name : "contact"
					}
				]
			}
		]
	});
};

export default createRouter;