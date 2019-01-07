# pony-appdirs

Library for detecting platform specific user directories e.g. for data, config, cache, logs.

## Status

[![CircleCI](https://circleci.com/gh/mfelsche/pony-appdirs.svg?style=svg)](https://circleci.com/gh/mfelsche/pony-appdirs)

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Update your `bundle.json`

```json
{ 
  "type": "github",
  "repo": "mfelsche/pony-appdirs"
}
```

* `stable fetch` to fetch your dependencies
* `use "appdirs"` to include this package
* `stable env ponyc` to compile your application
