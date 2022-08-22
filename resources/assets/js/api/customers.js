export const getCustomerList = api => ( params ) => api.get('/customers', { params : params} );
export const updateCustomer = api => ( data ) => data.id ? api.put( '/customers/' + data.id, JSON.stringify( data ) ) : api.post('/customers', JSON.stringify(data) );
export const getCustomer = api => ( authUser, params ) => api.get( '/customers/' + authUser.id,{ params: params } );
export const createAddress = api => ( authUser, address ) => api.post( '/customers/' + authUser.id + '/addresses', JSON.stringify( address ) );
export const updateAddress = api => ( authUser, address ) => api.post( '/customers/' + authUser.id + '/addresses/' + address.id, JSON.stringify( address ) );

export const customers = api => ({
  get: {
    customers: {
		get: getCustomer( api ),
    	list: getCustomerList( api )
    }
  },
  post: {
    customers: {
      	save: updateCustomer( api ),
	  	createAddress : createAddress( api )
    }
  },
  put: {
	customers: {
		update: updateCustomer( api ),
		updateAddress : updateAddress( api )
	}
  }
});

export default customers;