
Nurb::FS Module
---------------

- FS::watchFile(filename, [options], &block)
  + Polls `filename` for changes then calls `block` with the current and previous stat objects
  + The options argument may be omitted. If provided, it should be a hash
  + `options[:persistent]` indicates whether the process should continue to run as long as files are being watched
  + `options[:interval]` indicates whether the process should continue to run as long as files are being watched


SUCCESS [0 failed, 0 pending, 4 total]
