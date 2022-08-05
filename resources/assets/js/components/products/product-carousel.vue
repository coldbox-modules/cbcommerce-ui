<template>

    <div>

        <product-grid-loading :itemsOnStage="itemsOnStage"  v-if="isLoading"></product-grid-loading>

        <carousel
			:autoplay="autoPlay"
			:navigationEnabled="showNav"
			:paginationEnabled="showDots"
			:perPage="itemsOnStage"
		>
			<slide v-for="(product, index) in productsListArray" :key="index">
				<product-item

					:key="index"
					:product="product"
					v-on:quote-sku="showSkuQuoteForm"
				></product-item>
			</slide>
		</carousel>
        <sku-quote-modal v-if="quotedSKUId && showQuoteModal" v-on:quote-modal-close="toggleModal" :skuId="quotedSKUId"></sku-quote-modal>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import ProductItem from './product-item';
import ProductItemLoading from './product-item-loading';
import ProductGridLoading from "@cbCommerce/components/products/product-grid-loading";
import SkuQuoteMixin from '@cbCommerce/mixins/sku-quote-mixin';

export default {
    mixins : [ SkuQuoteMixin ],
    components: {
        ProductItemLoading,
        ProductItem,
        ProductGridLoading
    },

    props: {
        carouselId: {
            type   : String,
            default: 'carousel-bestseller'
        },
        itemsOnStage: {             // items on screen
            type   : Number,
            default: 4
        },
        showNav: {                  // show nav's prev and next buttons
            type   : Boolean,
            default: false
        },
        navContainer: {             // the nav container element
            type   : String,
            default: "#nav-bestseller"
        },
        showDots: {
            type   : Boolean,
            default: false
        },
        autoPlay: {
            type   : Boolean,
            default: false
        },
        listParams: {
            type : Object,
            required : false
        }
    },

    data() {
        return {
            fakes    : 4,
            products : null,
            isLoading: false,
        }
    },

    created() {
        this.isLoading = true;
        // Fetch the products
        this.fetchProducts();
    },
    computed: {
        ...mapGetters(
            [
                "productsListArray",
                "productsList",
                "currentProductID"
            ]
        )
    },

    methods: {

        ...mapActions([
            "getListOfProducts",
            "setCurrentProduct",
            "clearCurrentProduct",
            "addItemToCart"
        ]),

        fetchProducts(){
            const self = this;
            Promise.resolve( this.getListOfProducts( this.listParams ) )
            .then( () => {
                this.$set( self, "isLoading", false );
            } )
            .catch( err => console.error(err) );
        }

    }
}
</script>