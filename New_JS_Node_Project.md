# How to Set Up a New NodeJS Project

1. `mkdir <project> && cd <project>`
1. `git init`
1. Create a `.gitignore` file (see below)
1. `touch README.md`
1. Create MIT `LICENSE` file (see below)
1. Create empty remote git repository
1. `git add . && git commit -m 'Initial commit'`
1. `git remote add origin git@github.com:<user>/<project>.git && git push -u origin master`
1. `npm init`
1. `npm install -D babel-cli babel-core babel babel-plugin-transform-class-properties babel-plugin-transform-object-rest-spread babel-preset-env jest`
1. `npm install chalk minimist temp`
1. Create a `.babelrc` file (see below)
1. Create a `version.json5` (see below)
1. `mkdir src/`
1. `mkdir scratch && touch scratch/.gitkeep && git add scratch/.gitkeep`
1. Create a `src/version.js` (see below)
1. `npx stampver -u`
1. Add `package.json` content (see below) and update for each tool.
1. `touch src/<tool>.js && touch src/<tool>Tool.js`
1. Insert contents of `<tool>.js` and `<tool>Tool.js` files
1. `git add -A :/ && git commit -m 'New NodeJS project with versioning'`

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

## `package.json` (Partial)

```
  ...
  "bin": {
    "<tool>": "dist/<tool>.js"
  },
  "files": [
    "dist/**"
  ],
  "scripts": {
    "build": "babel src -d dist -s --ignore *.test.js",
    "debug:snap": "babel-node --inspect-brk src/<tool>.js",
    "test": "jest",
    "test:debug": "babel-node --inspect-brk ./node_modules/jest/bin/jest.js --runInBand"
  },
  "jest": {
    "testPathIgnorePatterns": [
      "node_modules/",
      "scratch/"
    ]
  },
  ...
```

## `<tool>.js`

```
#!/usr/bin/env node
import { XxxTool } from './XxxTool'
import chalk from 'chalk'

const log = {
  info: console.error,
  info2: function() { console.error(chalk.green([...arguments].join(' '))) },
  error: function() { console.error(chalk.red('error:', [...arguments].join(' '))) },
  warning: function() { console.error(chalk.yellow('warning:', [...arguments].join(' '))) }
}

const tool = new XxxTool(log)
tool.run(process.argv.slice(2)).then((exitCode) => {
  process.exit(exitCode)
}).catch((err) => {
  console.error(err)
})
```

## `<tool>Tool.js`

```
import parseArgs from 'minimist'
import { fullVersion } from './version'
import util from 'util'
import path from 'path'
import process from 'process'
import temp from 'temp'

export class MongoBackupTool {
  constructor(log) {
    this.log = log
  }

  async run(argv) {
    const options = {
      boolean: [ 'help', 'version', ... ],
    }
    this.args = parseArgs(argv, options)

    if (this.args.version) {
      this.log.info(`${fullVersion}`)
      return 0
    }

    if (this.args.help) {
      this.log.info(`
usage: tool <cmd> [options]

options:
  --help                        Shows this help.
  --version                     Shows the tool version.
`)
      return 0
    }

    ...

    return 0
  }
}

```
