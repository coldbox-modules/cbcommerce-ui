<template>

    <div class="row">

        <div class="col-lg-3">
            <div class="widget-title first-widget">
                <i class="fa fa-search"></i> Search
            </div>
            <div class="widget-block">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="input-group">
                            <input
                                @keyup.tab="fetchProducts()"
                                @keyup.enter="fetchProducts()"
                                @change="fetchProducts()"
                                type="text"
                                id="refine-from"
                                class="form-control"
                                v-model="refine_"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="widget-title first-widget">
                <i class="fa fa-money"></i> Price range
            </div>
            <div class="widget-block">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="input-group">
							<div class="input-group-prepend">
								<span class="input-group-text">{{ currencySymbol }}</span>
							</div>
                            <input
                                @keyup.tab="minPriceRangeChange()"
                                @keyup.enter="minPriceRangeChange()"
                                @change="minPriceRangeChange()"
                                type="text"
                                id="price-from"
                                class="form-control"
                                v-model.number="minPrice" />
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="input-group">
							<div class="input-group-prepend">
								<span class="input-group-text">{{ currencySymbol }}</span>
							</div>
                            <input
                                @keyup.tab="maxPriceRangeChange()"
                                @keyup.enter="maxPriceRangeChange()"
                                @change="maxPriceRangeChange()"
                                type="text"
                                id="price-to"
                                class="form-control"
                                v-model.number="maxPrice" />
                        </div>
                    </div>
                </div>
            </div>

			<template v-if="activeCategory && activeCategory.children.length">
				<div class="widget-title">
					<i class="fa fa-arrow-circle-down"></i> Sub-Categories
				</div>
				<div class="widget-block">
					<div class="overlay" v-if="isLoading">
						<generic-loader message="Please wait..."></generic-loader>
					</div>

					<div class="row">
						<div class="col-sm-12">
							<ul class="subcategory-links list-unstyled">
								<li
									v-for="category in activeCategory.children"
									:key="`subcat_${category.id}`">
									<label>
									<input
										type="checkbox"
										:name="`category_${category.id}`"
										:value="category.id"
										@change="categoriesFilterChange"> {{category.name}}</label>

									<ul :id="`childrens_${category.id}`" v-if="category.children.length" style="display: none;" class="subcategory-children-links list-unstyled">
										<li
											v-for="categoryc in category.children"
											:key="`subcat_${categoryc.id}`">
											<label>
											<input
												type="checkbox"
												:name="`category_${categoryc.id}`"
												:value="categoryc.id"
												@change="categoriesFilterChange"> {{categoryc.name}}</label>
										</li>

									</ul>

								</li>

							</ul>
						</div>
					</div>
				</div>
			</template>
            <div v-if="searchParams.condition && categoriesListArray.length" class="widget-title">
                <i class="fa fa-arrow-circle-down"></i> {{searchParams.condition}} Categories
            </div>
            <div v-if="searchParams.condition && categoriesListArray.length" class="widget-block">
                <generic-loader v-if="categoriesLoading" message="Loading categories..."></generic-loader>
                <div v-else class="row">
                    <div class="col-sm-12">
                        <ul class="subcategory-links list-unstyled">
                            <li
                                v-for="category in categoriesListArray"
                                :key="`subcat_${category.id}`">
                                <label>
                                <input
                                    type="checkbox"
                                    :name="`category_${category.id}`"
                                    :value="category.id"
                                    @change="categoriesFilterChange">{{category.name}}</label>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>

        <div class="col-lg-9">

            <filter-bar
                v-on:productLayoutChange="productLayoutChangeReaction"
                v-on:perPageChange="perPageChangeReaction"
                v-on:sortTypeChange="sortTypeChangeReaction"
                :isGrid="isGrid"
                :isList="isList"
                :perPage="perPage"></filter-bar>

            <div class="block-pagination block-pagination-top" v-if="!isLoading && pageCount > 1">

                <paginate
                    :initial-page="currentPage-1"
                    :pageCount="pageCount"
                    :prevText="'Prev'"
                    :nextText="'Next'"
                    :containerClass="'pagination'"
                    :click-handler="paginationCallback"
                    :hide-prev-next="true"
                ></paginate>

            </div>

            <template v-if="!isLoading && !productsListArray.length">
                <div class="text-center alert alert-info">
                    <h5 class="text-center">There are no products matching the requested criteria</h5>
                </div>

            </template>

            <template v-else>
                <products-grid
                    v-if="isGrid"
                    :products="productsListArray"
                    :isLoading="isLoading"
                    :fakes="fakes"
                ></products-grid>

                <products-list
                    v-if="isList"
                    :products="productsListArray"
                    :isLoading="isLoading"
                    :fakes="fakes"
                ></products-list>
            </template>

            <div class="block-pagination" v-if="!isLoading && pageCount > 1">

                <paginate
                    :initial-page="currentPage-1"
                    :pageCount="pageCount"
                    :prevText="'Prev'"
                    :nextText="'Next'"
                    :containerClass="'pagination'"
                    :click-handler="paginationCallback"
                    :hide-prev-next="true"
                ></paginate>

            </div>

        </div>

    </div>

</template>

<script>
import { mapGetters, mapActions, mapState, mapMutations } from "vuex";
import Paginate from 'vuejs-paginate'
import FilterBar from "./filter-bar";
import ProductsGrid from './products-grid';
import ProductsList from './products-list';
import ProductItemLoading from './product-item-loading';
export default {
    components: {
        Paginate,
        FilterBar,
        ProductsGrid,
        ProductsList,
        ProductItemLoading
    },
    props: {
        initialParams : {
            type : Object,
            required : false
        }
    },
    data() {
        return {
            fakes    : 6,
            products : null,
            isLoading: true,
            categoriesLoading: false,
            isGrid   : true,
            isList   : false,
            sortBy   : 'price:asc',
            perPage  : 15,
            currentPage : 1,
            minPrice : "",
            maxPrice : "",
            pageCount: 10,
            searchParams : {
                condition : "New"
            },
            refine_ : "",
            filterCategories : []
        }
    },

    created() {
        var self = this;
        if( this.initialParams ){
            Object.assign( this.searchParams, this.initialParams );
			if( this.initialParams.search ){
				this.refine_ = this.initialParams.search;
			}
        }
        this.fetchProducts();

        if( self.searchParams.condition && self.searchParams.condition !== "New"  ){
            this.$set( self, "categoriesLoading", true );
            this.getCategories( { "productCondition" : self.searchParams.condition } )
                    .then(
                        categoriesMap => {
                            this.$set( self, "categoriesLoading", false );
                        }
                    );
        }
    },

    computed: {
        ...mapGetters([
            "productsListArray",
            "productsList",
            "currentProductID",
            "activeCategory",
            "categoriesListArray",
			"currencySymbol"
        ])
    },

    methods: {

        ...mapActions([
            "getListOfProducts",
            "setCurrentProduct",
            "clearCurrentProduct",
            "addItemToCart",
            "getCategories"
        ]),

        fetchProducts(){
            var self = this;
            this.$set( self, "isLoading", true );
            self.searchParams.maxrows = parseInt( self.perPage );
            self.searchParams.page = self.currentPage;
            self.searchParams.search = self.refine_
            self.getListOfProducts( self.searchParams ).then( productsMap => {
            self.setPagination( productsMap.pagination );
            this.$set( self, "isLoading", false );
            } );
        },

        paginationCallback( pageNum ){
            this.$set( this, "currentPage", pageNum );
            document.documentElement.scrollTop = 0;
            document.body.scrollTop = 0;
            this.fetchProducts();
        },

        setPagination( pagination ){
            var self = this;
            this.$set( self, "currentPage" , pagination.page );
            this.$set( self, "perPage", pagination.maxrows );
            this.$set( self, "pageCount", Math.ceil( pagination.total / pagination.maxrows ) );
        },

        categoriesFilterChange( e ){
            console.log( e.target.value );
            let categoryId = e.target.value;
            if( this.filterCategories.indexOf( categoryId ) > -1 ){
                this.filterCategories.splice( this.filterCategories.indexOf( categoryId ), 1 );
            } else {
                this.filterCategories.push( categoryId );
            }
            if( this.filterCategories.length ){
                this.searchParams.category = this.filterCategories.join(',');
            } else {
                this.searchParams.category = this.initialParams.category;
            }
            let name="#childrens_"+categoryId;
            $(name).toggle();
            this.fetchProducts();
        },

        minPriceRangeChange(){
            if( isNaN( this.minPrice ) ){
                delete this.searchParams.minimumPrice;
            } else {
                this.searchParams.minimumPrice=this.minPrice;
            }
            this.fetchProducts();
        },
        maxPriceRangeChange(){
            if( isNaN( this.maxPrice ) || this.maxPrice == 0 ){
                delete this.searchParams.maximumPrice
            } else {
                this.searchParams.maximumPrice=this.maxPrice;
            }
            this.fetchProducts();
        },

        perPageChangeReaction(perPage){
            this.perPage = perPage;
            this.currentPage = 1;
            this.fetchProducts();
            let url=this.urlPatch(perPage,'perPage');
            window.history.pushState('perPage', 'perPage', url);
        },

        sortTypeChangeReaction(sortBy){
            if( !sortBy ){
                delete this.searchParms.sortBy;
            } else {
                this.searchParams.sortBy = sortBy;
            }
            this.fetchProducts();
            let url=this.urlPatch(sortBy,'sortBy');
            window.history.pushState('sortBy', 'sortBy', url);
        },

        productLayoutChangeReaction(type){
            switch( type ){
                case 'grid':
                    this.isGrid = true;
                    this.isList = false;
                    break;
                case 'list':
                    this.isGrid = false;
                    this.isList = true;
                    break;
            }
        },
        urlPatch( key,name ){
            let url = window.location.href.split('?')[0];
            let params = window.location.href.split('?')[1];
            if( params != undefined ){
                params = this.removeParam( key, name, params );
                url = url + '?' + params;
            }else{
                url = url + '?' + name + '=' + key;
            }
            return url;
        },
        removeParam(key, name, sourceURL) {
            let param;
            let val;
            let rtn;
            let params_arr = [];
            if (sourceURL !=undefined && sourceURL !== '') {
                params_arr = sourceURL.split('&');
                    for (var i = params_arr.length - 1; i >= 0; i -= 1) {
                        param = params_arr[i].split('=')[0];
                        val = params_arr[i].split('=')[1];
                            if (param === name) {
                                if(val!==key){
                                    params_arr[i]=name + '=' + key;
                                }
                            }
                    }
                rtn = params_arr.join('&');
            }
        return rtn;
        }
    }
}
</script>