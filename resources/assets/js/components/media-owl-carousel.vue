<template>
	<div>

		<div :class="carouselClass" v-if="isLoading">
			<div class="pic">
				Images loading...
			</div>
		</div>
		<template v-else>
			<carousel
				:class="carouselClass"
				:autoplay="autoPlay"
				:navigationEnabled="showNav"
				:paginationEnabled="showDots"
				:perPage="itemsOnStage"
			>

					<slide v-for="item in carouselData" :key="item.id">
						<div class="item">
							<div class="pic" v-if="getValue( item.name, 'href' ) != ''">
								<a :href="getValue( item.name, 'href' )">
									<img class="img-fluid" :src="getMediaPath( item.name )" :alt="getValue( item.name, 'alt' )" />
								</a>
							</div>
							<div class="pic" v-else>
								<img class="img-fluid" :src="getMediaPath( item.name )" :alt="getValue( item.name, 'alt' )" />
							</div>
						</div>
					</slide>
			</carousel>
		</template>
	</div>
</template>
<script type="application/javascript">
	export default {
		props: {
            carouselId: { 				// unique carousel Id
                type: String,
                required: true
            },
            carouselClass: {			// carousel class
            	type: String
            },
            mediaFolder: {				// media folder with images
            	type: String,
            	default: ""
            },
            fileList: {					// file list ( array of structs with each file's info)
            	type: Array
            },
            imageInfo: {				// images' info ( alt, href, name )
            	type: Object
            },
            itemsOnStage: {				// items on screen
            	type: Number,
            	default: 4
            },
            showNav: {					// show nav's prev and next buttons
            	type: Boolean,
            	default: false
            },
            autoPlay: {
            	type: Boolean,
            	default: false
            },
            navContainer: {				// media folder with images
            	type: String,
            	default: ""
            },

        },
		data() {
	        return {
	            isLoading: false,
	            carouselData: this.fileList
	        }
	    },
		methods: {
			getValue: function( fileName, key ){
				if( Object.keys( this.imageInfo ).length === 0 && this.imageInfo.constructor === Object ){
					return "";
				} else{
					if( this.imageInfo.hasOwnProperty( fileName ) && this.imageInfo[ fileName ].hasOwnProperty( key ) ){
						return this.imageInfo[ fileName ][ key ];
					} else {
						return "";
					}
				}
			},
			getMediaPath: function( fileName ){
				if( this.mediaFolder != "" ){
					return '/__media/' + this.mediaFolder + '/' + fileName;
				} else {
					return '/__media/' + fileName;
				}

			}
	    }

	}
</script>