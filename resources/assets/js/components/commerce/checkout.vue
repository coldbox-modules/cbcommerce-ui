<template>

    <div>
		<div class="col-sm-12" v-if="isLoading">
			<generic-loader message="Loading checkout information..."></generic-loader>
		</div>
		<div v-else-if="!checkoutMethod">
			<div class="col-md-6">
                <!--- TODO: Use setting to get the app name --->
                <h3>{{ $t('Sign_In' ) }}</h3>
                <login-form :success-url="`${storeBaseHref}/checkout`"></login-form>
            </div>
            <div class="col-md-6">
                <!--- TODO: Use setting to get the app name --->
                <h3>{{ $t( 'No_Account_q' ) }}</h3>
                <a @click="checkoutMethod='guest'" class="btn btn-secondary btn-lg">{{ $t( 'Checkout_as_a_guest' ) }}</a>
                <a :href="`${storeBaseHref}/account/create?returnTo=/checkout`" class="btn btn-primary btn-lg">{{ $t('Create_an_Account') }}</a>
            </div>
		</div>
    	<generic-loader v-else-if="checkoutStatus == 'pending'" message="Processing Your Order. Please wait..."></generic-loader>
    	<div v-else>
	    	<div class="col-md-9 block-form tabs-steps">
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" id="checkout-steps" role="tablist">
				    <li class="nav-item" id="shipping">
	                	<a
							:class="{ 'nav-link' : true, 'active' : activeTab === 'shipping' }"
	                		href="#shipping"
	                		@click.prevent="activateTab('shipping')">

	                		<i class="fa fa-truck"></i>
	                		Shipping
	                	</a>
	                </li>

	                <li v-if="isValidated.shipping" class="nav-item" id="payment">
	                	<a
							:class="{ 'nav-link' : true, 'active' : activeTab === 'payment' }"
	                		href="#payment"
	                		@click.prevent="activateTab('payment')"
	                		>

	                		<i class="fa fa-money"></i>
	                		Payment
	                	</a>
	                </li>
	                <li class="nav-item" v-else>
	                	<a
	                		@click="()=>false"
	                		class="nav-link disabled">
	                		<i class="fa fa-money"></i>
	                		Payment
	                	</a>
	                </li>

	                <li v-if="isValidated.payment" class="nav-item" id="review">
	                	<a
							:class="{ 'nav-link' : true, 'active' : activeTab === 'review' }"
	                		href="#review"
	                		@click.prevent="activateTab('review')">

		                	<i class="fa fa-check"></i>
		                	Order Review
	                	</a>
	                </li>
	                <li class="nav-item" v-else>
	                	<a
	                		href="#"
	                		class="nav-link disabled">
	                		<i class="fa fa-check"></i>
	                		Order Review
	                	</a>
	                </li>
	            </ul>

	            <!-- Tab panes -->
	            <div class="tab-content">
	                <div class="tab-pane" :class="{ 'active' : activeTab === 'shipping' }" id="shipping">
	                    <br>
	                    <h3>Shipping Address</h3>
	                    <hr>
						<address-form
							v-model="selectedShippingAddress"
							designation="shipping"
						></address-form>
						<div class="form-group">
							<div class="checkbox">
								<label>
									<input type="checkbox"
										v-model="sameAddress"
										:true-value="true"
										:false-value="false"
									>
									Use Shipping Address for Billing
								</label>
							</div>

						</div>
	                    <hr>
	                    <a :href="`/${$store.state.globalData.moduleEntryPoint}/shopping-cart`" class="btn btn-primary">Back to Cart</a>
	                    <a href="#payment"
	                    	class="btn btn-secondary"
	                    	@click.prevent="validateAddress( 'shipping', 'payment' )">
	                    	Next
	                    </a>
	                </div>

	                <div class="tab-pane" :class="{ 'active': activeTab === 'payment' }" id="payment">
	                    <stripe-processor
							v-if="isStripeConfigured && payment.processor == 'stripe'"
							:billingAddress="sameAddress ? selectedShippingAddress : selectedBillingAddress"
							@payment-validated="onPaymentValidated"
						></stripe-processor>
	                    <hr>
	                    <a
	                    	href="#shipping"
	                    	class="btn-default-1"
	                    	@click.prevent="activateTab('shipping')">

	                    	Back
	                    </a>
	                    <button
	                    	href="#review"
	                    	class="btn btn-default-1"
							:disabled="!isValidated.payment"
	                    	@click="validateAddress( 'billing', 'review' )">
	                    	Next
	                    </button>
	                </div>

	                <div class="tab-pane" :class="{ 'active': activeTab === 'review' }" id="review">
	                    <br>
	                    <h3>Review</h3>
	                    <br>
	                    <div
			    			v-for="(item, index) in cartProducts"
				            :key="index">

			    			<cart-item :item= "item" :show-actions="false">

							</cart-item>
						</div>

	                    <hr>
	                    <a href="#" class="btn-default-1" @click="purchase">Place Order</a>
	                </div>
	            </div>
	    	</div>

	    	<div class="col-md-3">
		     	<div class="cart-buy-box">
					<div v-if="isValidated.payment && isValidated.shipping">
						<button
							class="btn btn-animate btn-fluid"
							@click="purchase"
						>

							Place Order
						</button><br/><br/>
						<!--- TODO: Use setting to get the app name -->
						<p>By Placing your order, you agree to App's name Privacy Notice.</p>
					</div>
			     	<div class="cart-summary">
			     		<h4>Order Summary</h4>
			     		<table class="table">
			     			<tbody>
			     				<tr>
			     					<th>Sub Total:</th>
			     					<td class="text-right">{{ subtotal | currency }}</td>
			     				</tr>
			     				<tr>
			     					<th>Estimated Shipping:</th>
			     					<td class="text-right">{{ shippingCost | currency }}</td>
			     				</tr>
			     				<tr>
			     					<th>Total Before Tax: </th>
			     					<td class="text-right">{{ subtotal + shippingCost | currency }}</td>
			     				</tr>
			     				<tr>
			     					<th>Estimated Tax:</th>
			     					<td class="text-right">{{ tax | currency }}</td>
			     				</tr>
			     				<tr class="text-danger">
			     					<th>Order Total:</th>
			     					<td class="text-right">{{ subtotal + shippingCost + tax | currency }}</td>
			     				</tr>
			     			</tbody>
			     		</table>
			     	</div>

			    </div>
		     </div>
		</div>
    </div>
</template>
<script>
import { mapState, mapGetters, mapActions } from "vuex";
import api from "@cbCommerce/api/index";
import imagesLoaded from 'vue-images-loaded';
import CartItem from './cart-item';
import StripeProcessor from './processors/stripe';
import AddressForm from "@cbCommerce/components/commerce/address-form";

export default {
	components: {
		AddressForm,
        CartItem,
		StripeProcessor
    },
    directives: {
        imagesLoaded
    },
    data() {
        return {
			checkoutMethod: null,
            isLoading: false,
            hasCardErrors : false,
            cardErrorMessage: "",
            activeTab: 'shipping',
            isValidated: {
            	shipping: false,
            	payment: false
            },
            selectedShippingAddress: {
            	id: "",
            	fullName: "",
            	address1: "",
            	address2: "",
            	city: "",
            	province: "",
            	postalCode: ""
            },
            selectedBillingAddress: {
            	id: "",
            	fullName: "",
            	address1: "",
            	address2: "",
            	city: "",
            	province: "",
            	postalCode: ""
            },
            sameAddress: true,
			payment : {
				"processor" : "stripe"
			}
        }
    },
    computed: {
    	...mapState( {
    		globalData   : 'globalData'
    	}),
        ...mapGetters([
            "cartProducts",
			"checkoutStatus",
			"authUser",
			"storeBaseHref",
			"apiInstance",
			"isStripeConfigured"
        ]),
        subtotal: function(){
        	var subTotal = 0;
        	for( var i in this.cartProducts ){
        		let itemPrice = this.cartProducts[ i ].sku.displayPrice;
        		let qty = this.cartProducts[ i ].quantity;

        		subTotal = subTotal + ( itemPrice * qty )
        	}
        	return subTotal;
        },
        shippingCost: function(){
        	return 0;
        },
        tax: function(){
        	return 0;
        },
		shippingAddresses(){
			return this.authUser && this.authUser.addresses ? this.authUser.addresses.filter( address => address.designation == 'shipping' ) : [];
		},
		billingAddresses(){
			return this.authUser && this.authUser.addresses ? this.authUser.addresses.filter( address => address.designation == 'billing' ) : [];
		}
    },

    created() {
        this.isLoading = true;
    },
    mounted() {},
    methods: {
        ...mapActions([
            "setCheckoutStatus"
        ]),
        activateTab( tabRef ){
        	this.activeTab = tabRef;
        },
        availabilityText( inStock ){
            return ( inStock ) ? 'In Stock' : 'Out Of Stock';
        },
        validateAddress( designation, nextStep ){
        	var self = this;
        	this.$validator.validate( `form-${designation}.*` ).then(( result ) => {
		        if ( result ) {
				  if( !self.selectedShippingAddress.id ){
					self.apiInstance.post.customers.createAddress( self.authUser, self.selectedShippingAddress );
				  }
		          self.isValidated.shipping = true;
				  self.activateTab( nextStep );
				  this.$scrollTo( $( '#' + nextStep )[ 0 ] );
		        } else {
					self.isValidated.shipping = false;
					let $firstError = $( 'span.text-danger.error-message:visible' ).first();
					if( $firstError.length ){
						this.$scrollTo( $firstError[ 0 ], 500, { offset : -200 } );
					}
		        }
		    });
        },
		purchase(){
			let self = this;
			self.$store.commit('setCheckoutStatus', 'pending' );

			var payload = { ...self.payment };

	      	if ( payload.token != null && self.isValidated.shipping && self.isValidated.payment ) {
  				// set payload
  				payload.shippingAddress = self.selectedShippingAddress;
  				payload.billingAddress = self.selectedBillingAddress;
  				payload.source = payload.token;
				delete payload.token;
  				payload.subtotal = self.subtotal;
  				payload.shippingCost = self.shippingCost;
  				payload.tax = self.tax;

  				self.apiInstance.post.checkout.process( payload )
					.then( XHR => {
						self.$store.commit('setCheckoutStatus', 'success' );
						window.location.replace( '/store/checkout/thankyou/' + XHR.data.id );
					})
					.catch( err => {
						console.error( err );
						reject( err );
					})
					.then( xhr => {
						self.$store.commit('setCheckoutStatus', 'error' );
					});
  			}
		},
		onPaymentValidated( payment ){
			this.$set( this, "payment", { ...this.payment, ...payment } );
			this.$set( this.isValidated, "payment", true );
		}

    },
	watch : {
		authUser : {
			handler( newVal, oldVal ){
				if( newVal && newVal.id && !oldVal ){
					// scope in our global data user
					this.$set( this, "checkoutMethod", "auth" );
					var self = this;
					if( !this.selectedShippingAddress.firstName ){
						this.apiInstance.get.customers.get( newVal, { includes: "addresses" } ).then(
							XHR => {
								let merged = { ...this.authUser, ...XHR.data };
								self.$store.commit(
									"setAuthUser",
									merged
								);
								self.$nextTick( () => {

									if( this.shippingAddresses.length ){
										this.$set( this, "selectedShippingAddress", { ...this.shippingAddresses[ 0 ] } )
									} else {
										this.$set( this.selectedShippingAddress, "fullName", this.authUser.firstName + ' ' + this.authUser.lastName );
										this.$set( this.selectedShippingAddress, "designation", "shipping" );
									}

									if( this.billingAddresses.length ){
										this.$set( this, "selectedBillingAddress", { ...this.billingAddresses[ 0 ] } );
									} else {
										this.$set( this, "selectedBillingAddress", { ...this.selectedShippingAddress } );
										this.$set( this.selectedBillingAddress, "designation", "billing" );
									}

									this.isLoading = false;
								} )
							}
						)
					}
				} else if( this.globalData[ "@token" ] && newVal == null ){
					// user is not logged in
					this.isLoading = false;
				}
			},
			deep:true
		}
	}
}
</script>