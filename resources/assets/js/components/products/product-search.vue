<template>
    <div class="category-detail">
        <div class="col-xs-12 productDetailHeader">
            <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">Product Search</h1>
        </div>
        <div class="col-sm-12 category-products">
            <product-filter-page :initialParams="initialParams"></product-filter-page>
        </div>
    </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
import SubCategoryLinks from "@cbCommerce/components/categories/sub-category-links";
import ProductItemLoading from '@cbCommerce/components/products/product-item-loading';
import ProductFilterPage from '@cbCommerce/components/products/product-filter-page';

export default{
    data(){
        return {
            isLoading : false,
            initialParams : {},
			excludeParams : [
				"fwreinit",
				"cftoken",
				"cfide"
			]
        };
    },
    components: {
        SubCategoryLinks,
        ProductItemLoading,
        ProductFilterPage
    },
    computed : {
        ...mapGetters( [
            "activeCategory",
            "productsListArray"
        ] ),
        categoryId : () => {
            var locationParts = window.location.pathname.split( '/' );
            return locationParts[ locationParts.length - 1 ];
        }
    },
    methods : {
        ...mapActions([
            "getCategory",
            "getCategoryProducts",
            "updateCategoryViews"
        ]),
        imageProgress: function( instance, image ){
            var result = image.isLoaded ? 'loaded' : 'broken';
        }
    },
    title(){
        return !this.activeCategory ? null : this.activeCategory.name + ' | ' + document.title;
    },
    beforeMount(){
        var self = this;
        let queryParams = new URLSearchParams( window.location.search );
        queryParams.forEach( ( value, key ) => {
			if( self.excludeParams.indexOf( key.toLowerCase() ) == -1 ){
				self.initialParams[ key ] = value;
			}
        }  );
    }

}
</script>