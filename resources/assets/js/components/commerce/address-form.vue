<template>
	<div class="address-form" :data-vv-scope="`form-${designation}`">
		<div class="address-preview" v-if="!isEditing">
			<div class="well" v-if="!isSelecting">
				{{ address.fullName }}<br/>
				{{ address.address1 }}<br/>
				<span v-if="address.address2 != ''">{{ address.address2 }}<br/></span>
				{{ address.city }}, {{ address.province }} &nbsp;&nbsp;{{ address.postalCode }}<br/>
				<a @click="isEditing=true" class="text-sm pull-right">Edit</a>
				<a v-if="designatedAddresses.length > 1" @click="isSelecting=true" class="text-sm pull-right">Change</a>
			</div>
			<div v-else>
				<ul class="list-unstyled">
					<li class="well" v-for="option in designatedAddresses" :key="option.id">
						{{ option.fullName }}<br/>
						{{ option.address1 }}<br/>
						<span v-if="option.address2 != ''">{{ option.address2 }}<br/></span>
						{{ option.city }}, {{ option.province }} &nbsp;&nbsp;{{ option.postalCode }}<br/>
						<a @click="selectAddress( option.id )" class="text-sm pull-right">Select</a>
					</li>
				</ul>

			</div>
		</div>
		<div class="row" v-else>
			<div class="col-lg-6">
				<div class="form-group">
					<label for="shippingFullName" class="control-label">Full Name:
						<span class="text-danger">*</span>
					</label>
					<div>
						<input
							type="text"
							class="form-control"
							:id="`${designation}FullName`"
							:name="`${designation}FullName`"
							v-validate="'required'"
							data-vv-as="Full Name"
							v-model="address.fullName">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-shipping.shippingFullName')">

							{{ errors.first( 'form-shipping.shippingFullName' ) }}
						</span>
					</div>
				</div>
			</div>
			<div class="col-sm-12"></div>
			<div class="col-lg-6">
				<div class="form-group">
					<label for="shippingAddress1" class="control-label">Address:
						<span class="text-danger">*</span>
					</label>
					<div>
						<input
							type="text"
							class="form-control"
							:id="`${designation}Address1`"
							:name="`${designation}Address1`"
							v-validate="'required'"
							data-vv-as="Address"
							v-model="address.address1">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-shipping.shippingAddress1')">

							{{ errors.first( 'form-shipping.shippingAddress1' ) }}
						</span>
						<input
							type="text"
							class="form-control mt-2"
							id="shippingAddress2"
							v-model="address.address2">

					</div>
				</div>
				<div class="form-group">
					<label for="shippingCity" class="control-label">City:
						<span class="text-danger">*</span>
					</label>
					<div>
						<input
							type="text"
							class="form-control"
							:id="`${designation}City`"
							:name="`${designation}City`"
							v-validate="'required'"
							data-vv-as="City"
							v-model="address.city">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-shipping.shippingCity')">

							{{ errors.first( 'form-shipping.shippingCity' ) }}</span>
					</div>
				</div>

				<div class="form-group">
					<label for="shippingState" class="control-label">State/Province:
						<span class="text-danger">*</span>
					</label>
					<div>
						<input
							type="text"
							class="form-control"
							:id="`${designation}State`"
							:name="`${designation}State`"
							v-validate="'required'"
							data-vv-as="State"
							v-model="address.province">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-shipping.shippingState')">

							{{ errors.first( 'form-shipping.shippingState' ) }}
						</span>
					</div>
				</div>

				<div class="form-group">
					<label for="inputPostCode" class="control-label">Zip Code: <span class="text-danger">*</span></label>
					<div>
						<input
							type="text"
							class="form-control"
							:id="`${designation}PostCode`"
							:name="`${designation}PostCode`"
							v-validate="'required'"
							data-vv-as="Zip Code"
							v-model="address.postalCode">

						<span
							class="text-danger error-message"
							v-show="errors.has('form-shipping.shippingPostCode')">

							{{ errors.first( 'form-shipping.shippingPostCode' ) }}
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>
<script>
	import { mapGetters } from "vuex";
	export default {
		props: [ 'value', 'designation' ],
		data () {
			return {
				address: this.value,
				isEditing : false,
				isSelecting : false
			}
		},
		computed : {
			...mapGetters( [ "authUser" ] ),
			designatedAddresses(){
				return this.authUser ? this.authUser.addresses.filter( addr => addr.designation == this.designation ) : []
			}
		},
		beforeMount(){
			if( !this.value.id ){
				this.$set( this, "isEditing", true );
			}
		},
		methods: {
			handleInput : () => this.$emit( 'input', this.address ),
			selectAddress( id ){
				this.$set( this, "address", this.designatedAddresses.find( item => item.id == id ) );
				var self = this;
				this.$nextTick( () => {
					self.handleInput();
					self.$set( self, "isSelecting", false );
				} );
			}
		}
	}
</script>