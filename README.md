# appdirs

Library for detecting platform specific user directories e.g. for data, config, cache, logs.

Most stuff is copied from the python library [appdirs](https://github.com/ActiveState/appdirs) from ActiveState.

## Status

[![Actions Status](https://github.com/ponylang/appdirs/workflows/vs-ponyc-latest/badge.svg)](https://github.com/ponylang/appdirs/actions)

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Update your `bundle.json`

```json
{ 
  "type": "github",
  "repo": "ponylang/pony-appdirs"
}
```

* `stable fetch` to fetch your dependencies
* `use "appdirs"` to include this package
* `stable env ponyc` to compile your application
