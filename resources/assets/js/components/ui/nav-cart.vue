<template>

	<div>
		<span class="cart-icon">
			<span class="cart-count">{{ this.cartTotalQuantity }}</span>
		</span> <span class="hidden-xs">&nbsp; Cart</span>
	</div>

</template>

<script>
import { mapGetters, mapState, mapActions } from "vuex";
export default {

	created() {
		this.getCart();
	},
	computed: {
		...mapState({
			wishlists: state => state.wishlists.wishlists
		}),
		...mapGetters([
			"authUser",
			"cartTotalQuantity"
		])
	},
	methods: {
		...mapActions([
			"getCart",
			"getWishlists"
        ])
	},
	watch: {
		authUser : {
			handler( newVal, oldVal ){
				if( newVal && newVal.id && !this.wishlists ){
					this.getWishlists( { includes : "items" } );
				}
			},
			deep: true
		}
	}
}
</script>