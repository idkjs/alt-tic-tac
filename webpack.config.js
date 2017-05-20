let path = require('path')

module.exports = {
    entry: "./assets/app.js",
    output: {
        path: path.resolve(__dirname, "./priv/static/js"),
        filename: "app.js",
        devtoolModuleFilenameTemplate: '[absolute-resource-path]',
        devtoolFallbackModuleFilenameTemplate: '[absolute-resource-path]?[hash]'
    },
    devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            }
        ]
    }
}