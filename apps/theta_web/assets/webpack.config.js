const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const { merge } = require('webpack-merge')

const commonConfig = {

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
            loader: 'sass-loader'
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
    new MiniCssExtractPlugin({filename: '../css/[name].css'}),
    new CopyPlugin({
      patterns: [
        {from: "static/", to: "../"},
      ],
    }),
  ],
  optimization: {
    minimize: true,
    minimizer: [
      new CssMinimizerPlugin(),
    ],
  },
};

const productionConfig = {
  optimization: {
    minimize: true,
    minimizer: [
      new CssMinimizerPlugin({
        minimizerOptions: {
          preset: [
            'default',
            {
              discardComments: { removeAll: true },
            },
          ],
        },
      }),
    ],
  },
};

const developmentConfig = {};


module.exports = (env, argv) => {
  // console.log(env);
  // console.log("========");
  // console.log(argv.mode);
  switch(argv.mode) {
    case 'development':
      return commonConfig;
    case 'production':
      return merge(commonConfig, productionConfig);
    default:
      throw new Error('No matching configuration was found!');
  }
  // return null;
}