<template>

    <div class="row">

        <template v-if="isLoading">
            <div
                class="col-sm-12 col-md-6 col-lg-4 text-center mb-25"
                v-for="(fake, index) in fakes"
                :key="index">

                <product-item-loading></product-item-loading>

            </div>
        </template>

        <template v-if="!isLoading">
            <div
                class="col-sm-12 col-md-6 col-lg-4 text-center mb-25"
                v-for="(product, index) in products"
                :key="index">
                <product-item :product="product" v-on:quote-sku="showSkuQuoteForm"></product-item>

            </div>
        </template>

        <sku-quote-modal v-if="quotedSKUId && showQuoteModal" v-on:quote-modal-close="toggleModal" :skuId="quotedSKUId"></sku-quote-modal>

    </div>

</template>

<script>
import ProductItem from './product-item';
import ProductItemLoading from './product-item-loading';
import SkuQuoteMixin from '@cbCommerce/mixins/sku-quote-mixin';

export default {
    mixins : [ SkuQuoteMixin ],
    components: {
        ProductItemLoading,
        ProductItem
    },
    props: [
        'products',
        'isLoading',
        'fakes'
    ],
    data() {
        return {}
    },

    created: function(){},

    mounted() {},

    destroyed() {},

    methods: {

    }
}
</script>