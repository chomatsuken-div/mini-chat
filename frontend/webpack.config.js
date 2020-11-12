const path = require('path');
const webpack = require('webpack');
const { VueLoaderPlugin } = require('vue-loader');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

function resolve (dir) {
  return path.resolve(__dirname, dir)
}

const RAILS_ASSETS_ROOT = resolve('../app/assets/');

module.exports = {
  entry: resolve('./src/main.js'),
  output: {
    path: RAILS_ASSETS_ROOT,
    filename: 'javascripts/main.js',
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        use: {
          loader: 'vue-loader'
        }
      },
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: file => (
          /node_modules/.test(file) &&
          !/\.vue\.js/.test(file)
        )
      },

      {
        test: /\.(c|sc)ss$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  },
  resolve: {
    extensions: ['.vue', '.js'],
  },
  plugins: [
    new webpack.ProvidePlugin({
      'Vue': 'vue'
    }),
    new VueLoaderPlugin(),
    new MiniCssExtractPlugin({
      filename: 'stylesheets/main.css'
    })
  ]
};