let path = require('path')

module.exports = {
    entry: ["./assets/Index.bs.js", "./assets/css/index.styl"],
    output: {
        path: path.resolve(__dirname, "./priv/static/js"),
        filename: "app.js",
        devtoolModuleFilenameTemplate: '[absolute-resource-path]',
        devtoolFallbackModuleFilenameTemplate: '[absolute-resource-path]?[hash]'
    },
    mode: 'development',
    devtool: 'source-map',
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            },
            {
                test: /\.styl$/,
                use: [
                    {
                        loader: "style-loader" // creates style nodes from JS strings
                    },
                    {
                        loader: "css-loader" // translates CSS into CommonJS
                    },
                    {
                        loader: "stylus-loader" // compiles Stylus to CSS
                    }
                ]
            },
            {
                test: /\.css$/,
                loader: 'css-loader'
            },
        ]
    }
}
