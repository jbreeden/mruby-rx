# Rx

Rx is intended to provide a nodejs-like API for [mruby-libuv](https://github.com/jbreeden/mruby-libuv).

## Features

You can check [the docs](./docs) for API details, or [the tests](./specs) for
coding examples. I guess there's always [the code](./mrblib), too, while were at it.

## Dependencies

- Runtime: Just [mruby](https://github.com/mruby/mruby) and [mruby-libuv](https://github.com/jbreeden/mruby-libuv).
- Development: Using some features of [mruby-glib](https://github.com/jbreeden/mruby-glib) in the tests,
  so you'll need something similar to run them.
  
## Building

An example `build_config.rb`, including development dependencies, can be found 
[in my mruby fork](https://github.com/jbreeden/mruby/blob/libuv/build_config.rb).
