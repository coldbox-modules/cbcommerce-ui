<template>
    <div class="row wishlist-item-row">
		<div class="col-md-7 wishlist-item">
            <div class="wishlist-detail-item-image col-lg-4 col-md-6 col-sm-12">
                <a :href="`/store/product/${item.sku.product.id}`">
                    <img
                        class="img-fluid"
                        :title="item.sku.product.name"
                        :alt="item.sku.product.name"
                        :src="item.image.mediaItem.src" />
                </a>
            </div>
            <div class="wishlist-item-text col-lg-8 col-md-6 col-sm-12">
                <div class="wishlist-item-name">
                    <a :href="'store/product/'+ item.sku.product.id">{{ item.sku.product.name }}</a>
                </div>
                <div class="wishlist-item-actions">
                    <ul class="list-inline">
                        <li>
                            <a
                                v-if="item.sku.showPricing"
                                href="javascript:;"
                                @click="moveToCart"
                                v-tooltip="'Add this item to your cart'"
                                class="btn btn-primary"
                                style="width:145px;color:#fff"
                            >
                                <i class="fa fa-shopping-cart"></i> Add to cart
                            </a>

                            <a
                                v-else-if="globalData.features.quoting"
                                href="javascript:;"
                                @click="$emit( 'quote-open' )"
                                v-tooltip="'Request a quote for this item'"
                                class="btn btn-secondary"
                                style="width:145px;color:#fff"
                            >
                                    <i class="fa fa-envelope"></i> Request quote
                                </a>

                        </li>

                        <li>
                            <a href="javascript:;" @click="onDeleteItem">{{$t('Remove')}}</a>
                        </li>
                    </ul>
                </div>
            </div>
		</div>
		<div class="col-md-2">
			<div class="wishlist-item-price">
				<span class="sr-only">unit price</span>{{ item.sku.displayPrice | currency }}
			</div>
		</div>
		<div class="col-md-3">
			<div class="wishlist-item-quantity">
                <quantity-control
                    :showLabel="false"
                    :quantity="item.quantity"
					:sku="item"
                    v-on:quantityChange="onQuantityChange"
                ></quantity-control>
            </div>
		</div>
	</div>
</template>
<script>
import { mapActions, mapState } from "vuex";
import QuantityControl from '@cbCommerce/components/quantity-control';
export default{
    props : {
        item : {
            type : Object,
            reuquired : true
        }
    },
	computed: {
        ...mapState( {
            allWishlists : ( state ) => state.wishlists.wishlists,
			globalData : state => state.globalData
        } )
	},
    components: {
        QuantityControl
    },
    methods : {
        ...mapActions( [ "saveWishlist", "saveWishlistItem", "addItemToCart", "deleteWishlistItem" ] ),
        onQuantityChange : function( {quantity} ){
            var self = this;
            if( !quantity ) quantity=1;

            this.$set( self.item, "quantity", quantity );
            // send as a PATCH rather than PUT
            this.$set( self.item, "key", "quantity" );
            this.$set( self.item, "value", quantity );
            this.saveWishlistItem( self.item )
                    .catch( err => {
                        console.log( err );
                    })
                    .then( xhr => {
                        self.$delete( self.item, "key" );
                        self.$delete( self.item, "value" );
                    });
        },
        onDeleteItem( e ){
            var self = this;
            this.deleteWishlistItem( this.item )
                .then( ( {result} ) => {
                    self.$emit( "delete-item", this.item.id )
                } )
                .catch( err => {
                    console.error( err );
                } )
        },
        moveToCart( e ){
            var $btn = $( e.currentTarget );
            $( 'i', $btn ).removeClass( 'fa-cart' ).addClass( 'fa-spin fa-spinner' );
            let payload = {
                sku : this.item.sku.id,
                quantity : this.item.quantity
            };
            this.addItemToCart( payload )
                    .then( xhr => $( 'i', $btn ).removeClass( 'fa-spin fa-spinner' ).addClass( 'fa-cart' ) )
        }
    }

}
</script>