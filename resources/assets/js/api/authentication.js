export const getAuth = api => () => api.get( '/authentication' );
export const authenticate = api => ( payload ) => api.post( '/authentication', JSON.stringify( payload ) );
export const logout = api => ( itemId ) => api.delete( '/authentication' );
export const resetPassword = api => ( email ) => api.post( '/authentication/password-reset', JSON.stringify( { email : email } ) );
export const getToken = api => () => api.get( '/authentication/token' );

export const authentication = api => ({
  get: {
    authentication: {
    	get: getAuth( api ),
		token : getToken( api )
    }
  },
  post: {
    authentication: {
      login: authenticate( api ),
      resetPassword : resetPassword( api )
    }
  },
  delete: {
    authentication: {
      logout: logout( api )
    }
  }
});

export default authentication;
