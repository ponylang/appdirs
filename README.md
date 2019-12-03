# pony-appdirs

Library for detecting platform specific user directories e.g. for data, config, cache, logs.

Most stuff is copied from the python library [appdirs](https://github.com/ActiveState/appdirs) from ActiveState.

## Status

[![CircleCI](https://circleci.com/gh/ponylang/pony-appdirs.svg?style=svg)](https://circleci.com/gh/ponylang/pony-appdirs) [![Build status](https://ci.appveyor.com/api/projects/status/mns3ld1foja8mo7n/branch/master?svg=true)](https://ci.appveyor.com/project/ponylang/pony-appdirs/branch/master) [![Build Status](https://travis-ci.org/ponylang/pony-appdirs.svg?branch=master)](https://travis-ci.org/ponylang/pony-appdirs)

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
