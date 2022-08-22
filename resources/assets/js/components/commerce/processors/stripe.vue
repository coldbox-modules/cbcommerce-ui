<template>
<div class="row">
	<br>
	<h3>Billing Information</h3>
	<hr>
	<form role="form" method="post" action="#" data-vv-scope="form-payment">
		<div class="row payment-fields">
			<div class="col-lg-12 ">
				<div class="form-group">
					<label for="card-name" class="control-label">Name on Card:<span class="text-danger">*</span></label>
					<div>
						<input
							type="text"
							class="form-control"
							id="nameOnCard"
							name="nameOnCard"
							v-validate="'required'"
							data-vv-as="Name on Card"
							v-model="payment.address.fullName">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-payment.nameOnCard')">

							{{ errors.first( 'form-payment.nameOnCard' ) }}
						</span>
					</div>
				</div>
			</div>
			<div class="col-lg-12 ">
				<div class="form-group">
					<label for="card-number" data-tid="elements_examples.form.card_label">Card:<span class="text-danger">*</span></label>
					<div id="card-number" ref="cardNumber" class="field empty"></div>
				</div>
			</div>
			<div class="col-lg-6">
				<div class="form-group">
					<label for="card-expiry" class="control-label">Expiration Date:<span class="text-danger">*</span></label>
					<div id="card-expiry" ref="cardExpiry" class="field empty"></div>
				</div>
			</div>
			<div class="col-lg-2">
				<div class="form-group">
					<label for="card-cvc" class="control-label">CCV:<span class="text-danger">*</span></label>
					<div id="card-cvc" ref="cardCvc" class="field empty"></div>
				</div>
			</div>
			<div class="col-lg-12">
				<transition name="fade">
					<div class="error" role="alert" v-if="hasCardErrors">
						<span class="message text-danger error-message">{{ cardErrorMessage }}</span>
					</div>
				</transition>
			</div>
			<div class="col-lg-12">
				<address-form
					v-model="payment.address"
					designation="billing"
				></address-form>
				<div class="form-group" v-if="!payment.phone">
					<label for="contactPhone" class="control-label">Phone:
						<span class="text-danger">*</span>
					</label>
					<div>
						<input
							type="text"
							class="form-control"
							id="contactPhone"
							name="contactPhone"
							v-validate="'required|numeric'"
							data-vv-as="Phone"
							v-model="payment.phone">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-payment.contactPhone')">

							{{ errors.first( 'form-payment.contactPhone' ) }}
						</span>
					</div>
				</div>
				<div class="form-group" v-if="!payment.email">
					<label for="contactEmail" class="control-label">Email:
						<span class="text-danger">*</span>
					</label>
					<div>
						<input
							type="text"
							class="form-control"
							id="contactEmail"
							name="contactEmail"
							v-validate="'required|email'"
							data-vv-as="Email"
							v-model="payment.email">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-payment.contactEmail')">

							{{ errors.first( 'form-payment.contactEmail' ) }}
						</span>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

</template>
<script>
import { mapState, mapGetters } from "vuex";
import AddressForm from "@cbCommerce/components/commerce/address-form";
export default {
	components : {
		AddressForm
	},
	props : {
		billingAddress : {
			required: true
		}
	},
	data(){
		return {
			stripeInstance : null,
			stripeElements : null,
            token: null,
			payment : {
				"email" : "",
				"phone" : "",
				"address" : {
					fullName: "",
					address1: "",
					address2: "",
					city: "",
					province: "",
					postalCode: ""
				}
			},
			hasCardErrors : false
		}
	},
	beforeMount(){
		console.log( this.billingAddress )
		this.$set( this.payment, "address", this.billingAddress );
		this.$set( this.payment, "phone", this.authUser.primaryPhone );
		this.$set( this.payment, "email", this.authUser.email );
	},
	mounted(){
		this.stripeInstance = new Stripe( this.stripeSettings.stripeKey );
		var elements = this.stripeInstance.elements();

		var cardNumber = elements.create('cardNumber', { style: this.getBaseStyles(), classes: this.getElementClasses() });
		var cardExpiry = elements.create('cardExpiry', {  style: this.getBaseStyles()  });
		var cardCvc = elements.create('cardCvc', {  style: this.getBaseStyles() } );

		cardNumber.mount( this.$refs.cardNumber );
		cardExpiry.mount( this.$refs.cardExpiry );
		cardCvc.mount( this.$refs.cardCvc );

		this.registerElements( [ cardNumber, cardExpiry, cardCvc ] );

	},
	computed : {
		...mapGetters( [ "authUser" ] ),
		...mapState({
			stripeSettings : state => state.globalData.settings.payments.processors.find( proc => proc.name == 'Stripe' )
		})
	},
	methods : {
		validatePayment(){
        	var self = this;

	    	var billingData = self.payment.address;

			// Gather additional customer data we may have collected in our form.
			var additionalData = {
	            name: billingData.fullName || undefined,
	            address_line1: billingData.address1 || undefined,
	            address_line2: billingData.address1 || undefined,
	            address_city: billingData.city ? billingData.city : undefined,
	            address_state: billingData.province ? billingData.province : undefined,
	            address_zip: billingData.postalCode ? billingData.postalCode : undefined,
        	};

        	this.stripeInstance.createToken( cardNumber, additionalData ).then( function( result ) {
		      	// Access the token with result.token
		      	if ( result.error ) {
	  				self.hasCardErrors = true;
	  				self.cardErrorMessage = result.error.message;
	  				self.isValidated.payment = false;
					let $firstError = $( 'span.text-danger.error-message:visible', self.$el ).first();
					if( $firstError.length ){
						self.$scrollTo( $firstError[ 0 ] );
					}
	  			} else {
	  				this.$set( self, 'token', result.token );
	  				self.$validator.validate( 'form-payment.*' ).then(( result ) => {
				    	if ( result && self.token != null ) {
						  self.payment.token = self.token;
				          self.$emit( "payment-validated", self.payment );
				        } else {
							let $firstError = $( 'span.text-danger.error-message:visible', self.$el ).first();
							if( $firstError.length ){
								self.$scrollTo( $firstError[ 0 ] );
							}
				        }
				    });
	  			}
		    });
        },
		getToken(){
			let self = this;

			var billingData = self.billingAddress;

			// Gather additional customer data we may have collected in our form.
			var additionalData = {
	            name: self.payment.nameOnCard ? self.payment.nameOnCard : undefined,
	            address_line1: billingData.address1 ? billingData.address1 : undefined,
	            address_line2: billingData.address2 ? billingData.address1 : undefined,
	            address_city: billingData.city ? billingData.city : undefined,
	            address_state: billingData.province ? billingData.province : undefined,
	            address_zip: billingData.postalCode ? billingData.postalCode : undefined,
        	};

        	this.stripeInstance.createToken( cardNumber, additionalData ).then( function( result ) {
		      	// Access the token with result.token
		      	if ( result.error ) {
	  				self.hasCardErrors = true;
	  				self.cardErrorMessage = result.error.message;
	  			} else {
	  				this.$set( self, 'token', result.token );
	  			}
		    });

		},
		registerElements( elements ){
			let self = this;
			// Listen for errors from each Element, and show error messages in the UI.
		    elements.forEach( function ( element ) {
		        element.on( 'change', function ( event ) {
		            if ( event.error ) {
		            	self.hasCardErrors = true;
		                self.cardErrorMessage = event.error.message;
		            } else {
		            	self.hasCardErrors = false;
		            }
		        });

		        element.on( 'focus', function ( event ) {
		            self.hasCardErrors = false;
		            self.cardErrorMessage = '';
		        });

		    });
		},
        getElementClasses(){
        	var elementClasses = {
			    focus: 'focus',
			    empty: 'empty',
			    invalid: 'invalid',
			  };

			  return elementClasses;
        },
        getBaseStyles(){
        	var styles = {
        		base: {
			      color: '#555555',
			      fontSize: '14px',
			      fontSmoothing: 'antialiased',

			      ':focus': {
			        color: '#424770',
			      },

			      '::placeholder': {
			        color: '#9BACC8',
			      },

			      ':focus::placeholder': {
			        color: '#CFD7DF',
			      },
			    },
			    invalid: {
			      color: '#555555',
			      ':focus': {
			        color: '#FA755A',
			      },
			      '::placeholder': {
			        color: '#FFCCA5',
			      },
			    }
			};
        	return styles;
        }
	}
}

</script>