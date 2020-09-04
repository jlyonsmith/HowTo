# Make a Javascript Project Declaration Files

You can add a _definitely typed_ TypeScript definition to a Javascript project.

## Steps

Create `types` directory containing the following files:

```txt
types
├── index.d.ts
├── tsconfig.json
└── tslint.json
```

In the `tsconfig.json` file put:

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es5",
    "lib": ["es6"],
    "noImplicitAny": true,
    "noImplicitThis": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "baseUrl": "../",
    "typeRoots": ["../"],
    "types": [],
    "noEmit": true,
    "forceConsistentCasingInFileNames": true
  },
  "files": ["index.d.ts"]
}
```

In the `tslint.json` file put:

```json
{
  "extends": "dtslint/dtslint.json",
  "rules": {
    "adjacent-overload-signatures": false,
    "array-type": false,
    "arrow-return-shorthand": false,
    "ban-types": false,
    "callable-types": false,
    "comment-format": false,
    "dt-header": false,
    "eofline": false,
    "export-just-namespace": false,
    "import-spacing": false,
    "interface-name": false,
    "interface-over-type-literal": false,
    "jsdoc-format": false,
    "max-line-length": false,
    "member-access": false,
    "new-parens": false,
    "no-any-union": false,
    "no-boolean-literal-compare": false,
    "no-conditional-assignment": false,
    "no-consecutive-blank-lines": false,
    "no-construct": false,
    "no-declare-current-package": false,
    "no-duplicate-imports": false,
    "no-duplicate-variable": false,
    "no-empty-interface": false,
    "no-for-in-array": false,
    "no-inferrable-types": false,
    "no-internal-module": false,
    "no-irregular-whitespace": false,
    "no-mergeable-namespace": false,
    "no-misused-new": false,
    "no-namespace": false,
    "no-object-literal-type-assertion": false,
    "no-padding": false,
    "no-redundant-jsdoc": false,
    "no-redundant-jsdoc-2": false,
    "no-redundant-undefined": false,
    "no-reference-import": false,
    "no-relative-import-in-test": false,
    "no-self-import": false,
    "no-single-declare-module": false,
    "no-string-throw": false,
    "no-unnecessary-callback-wrapper": false,
    "no-unnecessary-class": false,
    "no-unnecessary-generics": false,
    "no-unnecessary-qualifier": false,
    "no-unnecessary-type-assertion": false,
    "no-useless-files": false,
    "no-var-keyword": false,
    "no-var-requires": false,
    "no-void-expression": false,
    "no-trailing-whitespace": false,
    "object-literal-key-quotes": false,
    "object-literal-shorthand": false,
    "one-line": false,
    "one-variable-per-declaration": false,
    "only-arrow-functions": false,
    "prefer-conditional-expression": false,
    "prefer-const": false,
    "prefer-declare-function": false,
    "prefer-for-of": false,
    "prefer-method-signature": false,
    "prefer-template": false,
    "radix": false,
    "semicolon": false,
    "space-before-function-paren": false,
    "space-within-parens": false,
    "strict-export-declare-modifiers": false,
    "trim-file": false,
    "triple-equals": false,
    "typedef-whitespace": false,
    "unified-signatures": false,
    "void-return": false,
    "whitespace": false
  }
}
```

Next, in the `index.d.ts` file define the exported types in the module.  Use the following as a base:

```ts
/// <reference types="node" />

// export ...
```

You can read about how to define different types of `export` in the TypeScript documentation.

Now, install the `dslint` tool to validate your `.d.js` files:

```bash
npm install -g dtslint
```

Add these lines to your `packages.json` file:

```json
{
  //...
  "types": "dist/index.d.ts",
  //...
  "scripts": {
    //...
    "test": "... && dtslint types",
    "build": "babel -D types/index.d.ts ..."
  }
}
```

## References

- [How To Publish JavaScript Libraries](https://medium.com/javascript-in-plain-english/how-to-publish-javascript-libraries-68b9dd22dbda)
- [TypeScript Declaration Files](https://www.typescriptlang.org/docs/handbook/declaration-files/introduction.html)
- [Unit testing TypeScript types with dtslint](https://koerbitz.me/posts/unit-testing-typescript-types-with-dtslint.html)