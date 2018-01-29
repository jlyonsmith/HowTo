# Ejecting a Create React App

Run `npm run eject`.

Open `config/webpack.config.dev.js` and `config/webpack.config.p and add path aliases and the SASS loader:

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

To the `package.json` add: 

```
{
  ...
  "dependencies": {
    "node-sass": ...
    "sass-loader": ...
  },
  "scripts": {
    ...
    "deploy": "scp -r build/* ubuntu@xyz:<site-dir>/"
  },
  ...
  "devDependencies": {
    "chalk": "^1.1.3"
  }
}
```

Rename all `.css` file to `.scss`:

```
find . -depth 2 -name \*.css -exec bash -c 'mv "$1" "${1%.css}.scss"' -- {} \;
```

And update the `import` statements for `src/App.js` and `src/index.js`.
