# Prettier

To reformat all files in a Node.js or other Javascript project with Prettier, do something like:

```
find . -name \*.js -not -path "**/node_modules/**" -not -path "**/dist/**" -exec prettier --write --config ./.prettierrc {} \;
```
