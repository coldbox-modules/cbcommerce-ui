<template>

    <div>

        <div class="header-for-light">
            <div>
                <h1 class="wow fadeInRight animated animated" data-wow-duration="1s">
                    {{ headerTitle }}
                </h1>
            </div>
            <div class="toolbar-for-light" id="nav-related"></div>
        </div>

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
import SkuQuoteMixin from '@cbCommerce/mixins/sku-quote-mixin';
export default {
    mixins : [ SkuQuoteMixin ],
    components: {
        ProductItemLoading,
        ProductItem
    },
    props: {
        headerTitle: {
            default: 'You may also need',
            type   : String
        },
        carouselId: {
            type   : String,
            default: 'carousel-related-products'
        },
        itemsOnStage: {             // items on screen
            type   : Number,
            default: 4
        },
        showNav: {                  // show nav's prev and next buttons
            type   : Boolean,
            default: false
        },
        showDots: {
            type   : Boolean,
            default: false
        },
        autoPlay: {
            type   : Boolean,
            default: false
        },
    },
    data() {
        return {
            fakes    : 3,
            products : null,
            isLoading: false
        }
    },

    created() {
        this.isLoading = true;
        this.fetchRelatedProducts();
    },

    destroyed() {},

    computed: {
        ...mapGetters([
            "productsListArray",
            "productsList",
            "currentProductID"
        ])
    },

    methods: {

        ...mapActions([
            "getListOfProducts",
            "setCurrentProduct",
            "clearCurrentProduct",
            "addItemToCart"
        ]),


        fetchRelatedProducts(){
            const self = this;
            Promise.resolve( this.getListOfProducts() )
            .then(() => {
                self.isLoading = false;
            })
            .catch(err => console.error(err));
        }

    }
}
</script>