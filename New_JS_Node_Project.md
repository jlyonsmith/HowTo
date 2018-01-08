# How to Set Up a New NodeJS Project

1. `mkdir new-project && cd new-project`
1. `git init`
1. Create empty remote git repository then `git add . && git commit -m 'Initial commit' && git push -u origin master`
1. `npm init`
1. `npm install -D babel-cli babel-core babel babel-plugin-transform-class-properties babel-plugin-transform-object-rest-spread babel-preset-env jest`
1. `npm install chalk minimist temp`
1. `touch README.md`
1. Create MIT `LICENSE` file (see below)
1. Create a `.babelrc` file (see below)
1. Create a `.gitignore` file (see below)
1. Create a `version.json5` (see below)
1. Create a `src/version.js` (see below)

## `LICENSE`

```
MIT License

Copyright (c) 2018 John Lyon-Smith

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## `.babelrc`

```
{
  "presets": [
    [ "env", { "targets": { "node": 8 } } ]
  ],
  "plugins": [
    "transform-class-properties",
    "transform-object-rest-spread"
  ]
}
```

## `.gitignore`

```
# See https://help.github.com/ignore-files/ for more about ignoring files.

# scratch
/scratch

# dependencies
/node_modules

# testing
/coverage

# production
/build

# misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

# logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
```

## `version.json5`

```
{
  filenames: [
    "package.json",
    "src/version.js",
    "scratch/version.tag.txt",
    "scratch/version.desc.txt"
  ],
  buildFormat: "full",
  tags: {
    major: 1,
    minor: 0,
    patch: 0,
    build: 0,
    revision: 0,
    tz: "America/Los_Angeles"
  },
  fileTypes: [
    {
      name: "Node Package",
      glob: "**/package.json",
      update: {
        search: "^(?<begin> *\"version\" *: *\")\\d+\\.\\d+\\.\\d+(?<end>\" *, *)$",
        replace: "${begin}${major}.${minor}.${patch}${end}"
      }
    },
    {
      name: "Javascript File",
      glob: "**/version.js",
      updates: [
        {
          search: "^(?<begin>\\s*export\\s*const\\s*version\\s*=\\s*')\\d+\\.\\d+\\.\\d+(?<end>'\\s*)$",
          replace: "${begin}${major}.${minor}.${patch}${end}"
        },
        {
          search: "^(?<begin>\\s*export\\s*const\\s*fullVersion\\s*=\\s*')\\d+\\.\\d+\\.\\d+-\\d+\\.\\d+(?<end>'\\s*)$",
          replace: "${begin}${major}.${minor}.${patch}-${build}.${revision}${end}"
        }
      ]
    },
    {
      name: "Commit tag file",
      glob: "**/*.tag.txt",
      write: "v${major}.${minor}.${patch}"
    },
    {
      name: "Commit tag description file",
      glob: "**/*.desc.txt",
      write: "Version ${major}.${minor}.${patch}-${build}.${revision}"
    }
  ]
}
```

## `src/version.js`

```
export const version = '1.0.0'
export const fullVersion = '1.0.0-20180101.0'
```
