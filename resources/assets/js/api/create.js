import Axios from "axios";
import { getCookie } from "tiny-cookie";
import configuration from "./configuration";

const env = process.env.NODE_ENV || "development";
const base = configuration.environment[env].api.base;
const timeout = configuration.environment[env].api.timeout;
let token = configuration.environment[env].api.token;

if (!token) {
  try {
    token = getCookie("_DID");
  } catch (e) {
    console.error("Could not get token from config environment or from cookie");
  }
}

const apiAxios = Axios.create({
	baseURL: base,
	crossDomain : true,
	withCredentials : true,
	timeout,
	headers : {
		"Content-Type" : "application/json"
	}
});

apiAxios.interceptors.request.use((config) => {
	config.headers[ "x-csrf-token" ] = window.cbcGlobalData ? window.cbcGlobalData[ "@csrfToken" ] : ""
	return config;
});

// Response interception to scope in CSRF tokens
apiAxios.interceptors.response.use(
	function( response ) {
		console.log( "interceptor response", response );
		if( response.headers  && response.headers[ "x-csrf-token" ] ){
			window.cbcGlobalData[ "@csrfToken" ] = response.headers[ "x-csrf-token" ];
		}
    	return response;
  	}
);

const finalAPI = apiAxios;

export default finalAPI;
