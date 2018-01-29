# Ejecting a Create React App

Run `npm run eject`.

Open `config/webpack.config.dev.js` and add path aliases and the SASS loader:

```
...
const srcPath = path.resolve(__dirname, '../src/')
...
module.exports = {
  ...
  resolve: {
    ...
    alias: {
      ...
      'styles': path.join(srcPath, '/assets/styles/'),
      'images': path.join(srcPath, '/assets/images/'),
      'icons': path.join(srcPath, '/assets/icons/'),
      'data': path.join(srcPath, '/assets/data/'),
      'fonts': path.join(srcPath, '/assets/fonts/'),
      'src': srcPath,
      ...
    },
    ...
  },
  ...
  module: {
    ...
    rules: [
      ...
      {
        oneOf: [
          ...
          {
            test: /\.(sass|scss)$/,
            use: [
              require.resolve('style-loader'),
              {
                loader: require.resolve('css-loader'),
                options: {
                  importLoaders: 1,
                },
              },
              {
                loader: require.resolve('sass-loader'),
              },
```

