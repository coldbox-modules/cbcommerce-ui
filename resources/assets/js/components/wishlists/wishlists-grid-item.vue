<template>
    <article class="wishlist light">

        <figure class="figure-hover-overlay">
            <a :href="`/store/wishlist/${wishlist.id}`">
                <div class="wishlist-item-image" v-if="primaryImage" :style="`background-image:url(${primaryImage})`">
					<div class="btn btn-secondary light-header-callout float-right">
						<span>
							<strong>Updated:</strong> {{ lastUpdateDisplay }}
						</span>
					</div>
				</div>
            </a>
        </figure>

        <div class="wishlist-caption">
            <h4 class="block-name">
                <a :href="`/store/wishlist/${wishlist.id}`" class="wishlist-name">{{ wishlist.name }}</a>
            </h4>
        </div>

        <p class="wishlist-caption"><strong>Products:</strong> {{wishlist.items.length}}</p>

    </article>
</template>
<script>
import moment from "moment";
import { mapState } from "vuex";
export default{
    props : {
        wishlist : {
            type : Object,
            required : true
        }
    },
    computed : {
        ...mapState({
            primaryImage( state ){
                return this.wishlist.items.length && this.wishlist.items[ 0 ].image.id ? this.wishlist.items[ 0 ].image.mediaItem.src : state.globalData.placeholderImage;
            }
        }),
        lastUpdateDisplay(){
            let today = moment( new Date() );
            let lastModified = moment( new Date( this.wishlist.modifiedTime ) );
            let diff = parseInt( moment.duration( today.diff( lastModified ) ).asDays() );
            if( diff > 0 ){
                return diff + ( diff > 1  ? " days" : "day" ) + " ago";
            } else {
                return "Today";
            }
        }
    }
}
</script>