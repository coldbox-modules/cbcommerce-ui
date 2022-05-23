import Vue from "vue";

const getLocationHostname = () => window.location.hostname;
const errorHandler = () => (err) => {
  if (err && err.response.data.error) {
    return err.response.body.messages;
  } else if (err) {
    // all other error types we handle generically
    return err;
  }
};

export const config = {
  cookieName: "_DID",
  environment: {
    development: {
      api: {
        base        : window.cbcGlobalData.baseAPIHref,
        token       : "",
        timeout     : 60000,
        errorHandler: errorHandler(),
      }
    },
    stage: {
      debug: false,
      api: {
        base        : window.cbcGlobalData.baseAPIHref,
        timeout     : 60000,
        errorHandler: errorHandler(),
      }
    },
    production: {
      debug: false,
      api: {
        base        : window.cbcGlobalData.baseAPIHref,
        timeout     : 60000,
        errorHandler: errorHandler(),
      }
    }
  }
};

export default config;
