const path = require("path");
// const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const MomentLocalesPlugin = require("moment-locales-webpack-plugin");

module.exports = {
  mode: "production",
  entry: {
    app: "./interface/src/index.js",
  },
  module: {
    rules: [
      {
        test: /\.(j|t)sx?$/,
        use: {
          loader: "babel-loader",
          options: {
            presets: [
              "@babel/preset-env",
              "@babel/typescript",
              "@babel/preset-react",
            ],
            plugins: [
              "lodash",
              "@babel/transform-runtime",
              "@babel/plugin-proposal-object-rest-spread",
              "@babel/plugin-proposal-optional-chaining",
              "@babel/plugin-proposal-class-properties",
            ],
          },
        },
        exclude: /node_modules/,
      },
      {
        test: /\.css$/i,
        use: [
          // Creates `style` nodes from JS strings
          "style-loader",
          // Translates CSS into CommonJS
          "css-loader",
          // Compiles Sass to CSS
          "sass-loader",
        ],
      },
    ],
  },
  resolve: {
    extensions: [".js", ".ts", ".tsx"],
  },
  devtool: "source-map",
  // devServer: {
  //   contentBase: path.join(__dirname, './'),
  //   hot: true,
  //   port: 9000,
  //   historyApiFallback: true
  // },
  plugins: [
    new MomentLocalesPlugin(),
    new CleanWebpackPlugin(),
    // new HtmlWebpackPlugin({
    //   title: 'Hot Module Replacement',
    //   template: './public/index.html',
    // }),
  ],
  output: {
    filename: "index.js",
    path: path.resolve(__dirname, `./urbit/app/calendar/js`),
    publicPath: "/",
    hashFunction: "sha256",
  },
  optimization: {
    minimize: true,
    usedExports: true,
  },
};
