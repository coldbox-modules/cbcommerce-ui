<template>

    <div class="col-sm-12 col-md-6 col-lg-4 text-center mb-25">

        <article class="category light">
			<figure class="figure-hover-overlay">
				<a :href="`/store/category/${category.id}`">
					<img
						v-if="primaryImageSrc"
						:src="thumbnailSrc"
						:alt="category.name"
						class="img-responsive" />
				</a>

				<div class="category-caption">
					<div class="block-name">
						<a :href="`/store/category/${category.id}`" class="category-name">{{ category.name }}</a>
					</div>
				</div>

				<sub-category-links
					v-for="(subCat, index) in category.children"
					:key="index"
					:subCat="subCat"></sub-category-links>

			</figure>
        </article>

    </div>

</template>

<script>
import imagesLoaded from 'vue-images-loaded';
import CategoryGridItemLoading from './category-grid-item-loading';
import SubCategoryLinks from './sub-category-links';
export default {
    components: {
        CategoryGridItemLoading,
        SubCategoryLinks
    },
    directives: {
        imagesLoaded
    },
    props: [
        'category'
    ],
    computed: {
		primaryImageSrc(){
            return this.category.media.length ? this.category.media[ 0 ].mediaItem.src : '';
        },
		thumbnailSrc(){
			if( this.primaryImageSrc ){
				let parts = this.primaryImageSrc.split( "." );
				parts[ parts.length-2 ] += "_400x400";
				return parts.join( "." )+"?fit";
			} else {
				return "";
			}
		}
	}
}
</script>

<style>

</style>