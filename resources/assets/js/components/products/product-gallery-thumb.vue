<template>

    <a
        v-on:click="swap"
        href="javascript:;"
        :data-image="mainImage"
        :data-zoom-image="zoomImage"
        class="elevatezoom-gallery">
        <img
            :src="thumbImage"
        />
    </a>

</template>


<script>
export default {

    props: [
        'galleryItem',
        'totalThumbs'
    ],

    data() {
        return {
            mainImage : null,
            zoomImage : null,
            thumbImage: null
        }
    },
    mounted(){
        this.parseContent();
        this.$emit( 'thumbLoaded' );
    },
    methods: {

        swap: function(){

            var smallImage = this.$el.getAttribute( 'data-image' );
            var largeImage = this.$el.getAttribute( 'data-zoom-image' );

            if( $( '#product-zoom' ).length ){
                var ez = $( '#product-zoom' ).data( 'ezPlus' );
                ez.swaptheimage( smallImage, largeImage );
            }
        },

        parseContent: function(){
            var self          = this;
            var parsedContent = self.galleryItem;
            self.mainImage    = parsedContent.mediaItem.src;
            self.zoomImage    = parsedContent.mediaItem.src;
            self.thumbImage   = parsedContent.mediaItem.src;
        }

    }

}
</script>