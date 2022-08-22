import get from "lodash/get";
import api from "@cbCommerce/api/index";
import Vue from "vue";

const initialState = {};

const getters = {
    authUser: ( state, getters, rootState ) => rootState.globalData.cbcAuthUser || null,
	hasPermission: ( state, getters ) => ( thePermission ) => getters.authUser ? getters.authUser.scope.split( " " ).some( perm => thePermission.split( "," ).indexOf( perm ) > -1 ) : false,
	isInRole: ( state, getters ) => ( theRole ) => getters.authUser ? getters.authUser.roles.some( role => theRole.split( "," ).indexOf( role.name ) > -1 ) : false
};
const actions = {
    authenticate: ( context, { email, password } ) => {
        return new Promise( (resolve, reject) => {
            api().post.authentication.login( { email, password } )
						.then( XHR => {
							context.commit( 'setAuthUser', XHR.data, { root: true } );
							resolve( XHR.data );
						} )
						.catch( err => {
                            console.error(err);
							reject( "Error: The user could not be authenticated" );
						});
		} );
    },
    logout: ( context ) => {
    	new Promise( (resolve, reject) => {
	        api().delete.authentication.logout()
                .then( XHR => {
                    context.commit( 'setAuthUser', null, { root: true } );
                    window.location.reload();
                    resolve( XHR.data );
                } )
                .catch( err => {
                    console.error( err );
					reject( "Error: An error occurred when attempting to log out the user" );
                } )
	    } );
    }
};

export default {
    state: initialState,
    getters,
    actions
}