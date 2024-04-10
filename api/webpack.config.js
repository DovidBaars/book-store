const path = require('path');

module.exports = {
  entry: {
    createBook: './createBook/index.ts',
    retrieveBook: './retrieveBook/index.ts',
    deleteBook: './deleteBook/index.ts',
    updateBook: './updateBook/index.ts',
  },
  target: 'node',
  mode: 'production',
  output: {
    path: path.resolve('dist'),
    filename: '[name]/[name].js',
    libraryTarget: 'commonjs',
  },
  resolve: {
    extensions: ['.ts', '.js'],
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader',
      },
    ],
  },
};