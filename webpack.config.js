const elixir = require("coldbox-elixir");
const webpack = require("webpack");
const path = require("path");

elixir.config.mergeConfig({
	resolve: {
        alias: {
          vue: 'vue',
          Vue: 'vue',
          jQuery : "jquery",
		  ["@cbCommerce"]: `${path.dirname(__filename)}/resources/assets/js`
        }
    },
    plugins : [
        new webpack.ProvidePlugin( {
            $              : "jquery",
            jquery         : "jquery",
            "window.jQuery": "jquery",
            jQuery         : "jquery"
        } )
    ]
});

module.exports = elixir(function(mix) {
	mix
    .sass("app.scss")
	.sass(
            [
                "resources/assets/sass/vendor.scss"
            ],
            {
                name: "vendor",
                entryDirectory: ""
            }
        );

    mix.vue("app.js");
});
