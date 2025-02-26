<template>

    <div class="container">

        <template v-if="!isLoading">

            <div class="text-center item">

                <article class="product light">
                    <figure class="figure-hover-overlay">
                        <a :href="`/store/product/${product.id}`"  class="figure-href"></a>
                        <div v-if="isNew" class="product-new">New</div>
                        <div
                            class="product-sale"
                            v-if="hasPricing && product.startingPrice.basePrice < product.startingPrice.MSRP">{{ percentOff }}% <br> off</div>

                        <wishlist-add-icon :skuId="product.startingPrice.SKU"></wishlist-add-icon>

                        <comparison-add-icon :skuId="product.startingPrice.SKU"></comparison-add-icon>

                        <div class="product-item-image" v-if="productImageSrc.length" :style="`background-image:url(${productImageSrc})`"></div>
                        <div class="product-item-image-placeholder" v-else>
                        </div>
                    </figure>
                    <div class="product-caption">
                        <div class="block-name">
                            <a :href="`/store/product/${product.id}`" class="product-name">{{ product.name | removeHTML( 100 ) }}</a>
                                <div v-if="hasPricing">
                                    <div v-if="product.startingPrice.basePrice < product.startingPrice.MSRP" class="priceWithDiscount">
                                        <span>{{ product.startingPrice.MSRP | currency }}</span> {{ product.startingPrice.basePrice | currency }}
                                    </div>
                                    <div v-else>
                                        <p class="product-price">{{ product.startingPrice.basePrice | currency }}</p>
                                    </div>
                                </div>
                                <div v-else>
                                    <p class="product-price">&nbsp;</p>
                                </div>
                        </div>
                    </div>
                    <p v-if="product.externalId" class="tag_number">
                        {{product.externalId}}
                    </p>
                    <div v-if="product.startingPrice.pickUpInStore" class="round_section_label">
                        <p class="pickup" >In Store Pick Up</p>
                    </div>

                    <div v-if="hasPricing" class="product-cart">
                        <a
                            @click="addItemToCart( { sku: product.startingPrice.SKU, quantity: 1 } )"
                            v-tooltip="'Add this item to your cart'"
                            class="btn"><i class="fa fa-shopping-cart"></i> Add to cart</a>
                    </div>
                    <div v-else-if="globalData.features.quoting" class="product-request">
                        <a href="javascript:;"
                            @click="$emit( 'quote-sku', product.startingPrice.SKU )"
                            v-tooltip="'Request a quote for this item'"
                            class="btn"><i class="fa fa-envelope"></i> Request quote</a>
                    </div>

                </article>

            </div>

        </template>

        <template v-else>
            <product-item-loading></product-item-loading>
        </template>

    </div>

</template>

<script>
import { mapGetters, mapActions } from "vuex";
import imagesLoaded from 'vue-images-loaded';
import ProductItemLoading from './product-item-loading';
import moment from "moment";

let wishlistsMixin = require( '@cbCommerce/mixins/wishlists-mixin.js' ).default;

export default {
    mixins : [ wishlistsMixin ],
    components: {
        ProductItemLoading
    },
    directives: {
        imagesLoaded
    },
    props: [
        'product'
    ],
    data() {
        return {
            isLoading  : false
        }
    },

    created: function(){
        this.isLoading = true;
    },

    mounted() {
        this.isLoading = false;
    },

    computed: {
        ...mapGetters([
            "cartProducts"
        ]),
		globalData(){
			return this.$store.state.globalData;
		},
        hasPricing(){
            return this.product.startingPrice && this.product.startingPrice.basePrice;
        },
        isNew(){
            return moment( new Date( this.product.createdTime ) ) > moment( new Date() ).subtract( "30 days" );
        },
        percentOff(){
            return parseInt( 100 * ( 1 - ( this.product.startingPrice.basePrice / this.product.startingPrice.MSRP ) ) );
        },
        productImageSrc(){
            var self = this;
            var mediaSrc = '';
            this.product.media.forEach( media => {
                if( !mediaSrc.length && self.isImage( media.mediaItem ) ){
                    mediaSrc = media.mediaItem.src;
                }
            });

            return mediaSrc;
        }
    },

    methods: {
        ...mapActions([
            "addItemToCart",
            "addItemToWishlist"
        ]),
        isImage: function( mediaItem ){
            return this.$options.filters.isImage( mediaItem.mediaItem || mediaItem );
        },
        imageProgress: function( instance, image ){
            var result = image.src ? 'loaded' : 'broken';
        }


    }
}
</script>