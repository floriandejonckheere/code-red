module.exports = {
  resolve: {
    modules: [
      'node_modules',
    ],
  },
  module: {
    rules: [
      // {
      //   test: /sigma.*/,
      //   use: 'imports-loader?this=>window',
      // },
      {
        // You can use `regexp`
        // test: /example\.js/$
        test: /sigma.*/,
        use: [
          {
            loader: 'imports-loader',
            options: {
              type: 'commonjs',
              imports: {
                moduleName: 'sigma',
                name: 'Sigma',
              },
              wrapper: {
                thisArg: 'window',
                args: ['Sigma'],
              },
            },
          },
        ],
      },
    ],
  }

}
