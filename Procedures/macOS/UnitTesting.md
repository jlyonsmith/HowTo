# Unit Testing

## Configuring Jest for Code Coverage

Run:

```
jest --coverage --coverageDirectory coverage
```

in the project root. Then:

```
open coverage/lcov-report/index.html
```

Refresh this document manually each time you run a test. It's a good idea to put this in the `package.json`:

```
  "jest": {
    ...
    "collectCoverage": true,
    "coverageDirectory": "coverage"
    ...
  },
```

## Dependency Injection

Every class should have a constructor that takes a single `container` argument. This `container` has all of the _injected_ external dependencies needed by the class.

## Strategy

Start by trying to get the code coverage up as high as possible as quickly as possible. Always focus on the biggest uncovered areas. You want to try and hit ~80% eventually.

Each test setup should be as isolated as possible from other tests. This may result in code duplication, but it will make the tests much more robust.

Give the test a name that is the function or method that is being tested and the parameters that are being passed
