const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (options) => ({
  optimization: {
    minimizer: [
      new TerserPlugin({ cache: true, parallel: true, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  },
  entry: {
    front: glob.sync('./vendor/**/*.js').concat(['./js/front.js']),
    app: glob.sync('./vendor/**/*.js').concat(['./js/app.js']),
    editor: glob.sync('./vendor/**/*.js').concat(['./js/editor.js'])
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, '../priv/static/js'),
    library: '[name]',
    libraryTarget: 'var'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        },
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader']
      },
      {
        test: /\.(scss|sass)$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader'
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: true,
              // options...
            }
          }
        ]
      },
      {
        test: /\.(woff(2)?|ttf|eot|svg|otf)(\?v=\d+\.\d+\.\d+)?$/,
        use: [{
          loader: 'file-loader',
          options: {
            name: '[name].[ext]',
            outputPath: '/fonts/'
          }
        }]
      },
      {
        test: /\.(png|jpg|webp)(\?v=\d+\.\d+\.\d+)?$/,
        use: [{
          loader: 'file-loader',
          options: {
            name: '[name].[ext]',
            outputPath: '/images/'
          }
        }]
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: '../css/[name].css' }),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
  ]
});
