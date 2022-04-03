// Import our jQuery and Bootstrap extensions
import Vue from "vue";
import "bootstrap/dist/js/bootstrap.js";
import BootstrapVue from 'bootstrap-vue';
import PrettyCheckbox from 'pretty-checkbox-vue';
import VueTruncate from 'vue-truncate-filter';
import VTooltip from 'v-tooltip';
import { VueSlideoutPanel } from 'vue2-slideout-panel';
import Grid from 'vue-js-grid';
import VueCurrencyFilter from 'vue-currency-filter';
import VueCharts from 'vue-chartjs';
import VueNestable from "vue-nestable";
import VueI18n from "vue-i18n";

// Module components
import PageHeader from '@cbCommerce/admin/components/ui/page-header';
import BackButton from '@cbCommerce/admin/components/ui/back-button';
import TablePagination from '@cbCommerce/admin/components/ui/table-pagination';
import DismissableAlert from '@cbCommerce/admin/components/ui/dismissable-alert';

import Vuex from 'vuex';
import Router from 'vue-router';

import { sync } from 'vuex-router-sync';

import createStore from "@cbCommerce/admin/store";
import createRouter from "@cbCommerce/admin/router";
import createFilters from "@cbCommerce/filters/index";

import App from "@cbCommerce/admin/App";

const storeInstance  = createStore( Vue, Vuex );
const routerInstance = createRouter( Vue, Router, storeInstance );

routerInstance.beforeEach((to, from, next) => {
	if ( !storeInstance.getters.authUser && to.name !== 'login' ) {
		next({ name: 'login' });
	} else {
		next();
	}
});

sync( storeInstance, routerInstance );

Vue.use(VueI18n);
Vue.use( VueTruncate );
Vue.use( VTooltip );
Vue.use( PrettyCheckbox );
Vue.use( BootstrapVue );
Vue.use( Grid );
Vue.use( VueCharts );
Vue.use( VueNestable );

Vue.component( 'slideout-panel', VueSlideoutPanel );
Vue.component( 'page-header', PageHeader );
Vue.component( 'back-button', BackButton );
Vue.component( 'table-pagination', TablePagination );
Vue.component( 'dismissable-alert', DismissableAlert );
Vue.component( "generic-loader",  require( "@cbCommerce/components/generic-loader" ).default );

// Create VueI18n instance with options
const messages = window.cbcGlobalData.i18n;
const i18n = new VueI18n({
    locale: window.cbcGlobalData.fwLocale, // set locale
    messages, // set locale messages
});

Vue.use(
	VueCurrencyFilter,
	{
		symbol            : '$',
		thousandsSeparator: ',',
		fractionCount     : 2,
		fractionSeparator : '.',
		symbolPosition    : 'front',
		symbolSpacing     : false
	}
);

// global event bus
window.Event = new Vue();

new Vue( {
    i18n,
	store     : storeInstance,
	router    : routerInstance,
	filters   : createFilters( Vue ),
	components: { App }
} ).$mount( "#app" );
