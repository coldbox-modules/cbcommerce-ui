<template>
	<div class="row cart-product-row">
		<div class="col-md-7">
			<div class="cart-product">
				<div class="cart-product-image">
					<a :href="`/store/product/${item.product.id}`">
                        <img
							class="img-fluid mt-2"
                            :title="item.product.name"
                            :alt="item.product.name"
                            :src="primaryImage" />
                    </a>
                </div>
                <div class="cart-product-text">
					<div class="cart-product-name">
						<a :href="'store/product/'+ item.product.id">{{ item.product.name | removeHTML }}</a>
					</div>
					<div class="cart-product-actions mt-2" v-if="showActions">
						<ul class="list-inline">
							<li>
								<a href="" @click.prevent="deleteCartItem( item.sku.id )">Remove</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-md-2">
			<div class="cart-product-price">
				<span class="sr-only">unit price</span>{{ item.sku.displayPrice | currency }}
			</div>
		</div>
		<div class="col-md-3">
			<div class="cart-product-quantity">
                <quantity-control
                    :showLabel="false"
                    :quantity="item.quantity"
					:sku="item.sku"
                    v-on:quantityChange="quantityChangeReaction"
                ></quantity-control>
            </div>
		</div>
	</div>
</template>
<script type="text/javascript">
	import { mapGetters, mapActions } from "vuex";
	import QuantityControl from '@cbCommerce/components/quantity-control';

	export default{
		components:{
			QuantityControl
		},
		props: {
	        item: {
	            required: true,
	            type: Object
	        },
	        showActions: {
	        	type: Boolean,
	        	default: true
	        }
	    },
		computed: {
            primaryImage( state ){
                return this.item.sku.image ? this.item.sku.image.mediaItem.src : ( this.item.product.image ? this.item.product.image.mediaItem.src : this.$store.state.globalData.placeholderImage );
            }
		},
	    methods: {
	        ...mapActions([
				"deleteCartItem",
				"updateCartItem"
	        ]),

	        quantityChangeReaction: function( {quantity, sku} ){
				if(! quantity ) quantity=1;
				console.log( quantity );
				this.$set( this.item, "quantity", quantity );
				this.updateCartItem( { sku : sku.id, quantity: quantity } );
	        }
		}
	}
</script>