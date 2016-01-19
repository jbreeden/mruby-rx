
Nurb Timers
-----------

- Kernel#set_timeout(delay, &block)
  + Runs `block` after `delay` milliseconds

- Kernel#clear_timeout(timeout)
  + Cancels the timeout returned by set_timeout

- Kernel#set_interval(delay, &block)
  + Runs `block` after every `delay` milliseconds

- Kernel#clear_interval(interval)
  + Cancels the interval returned by set_interval

- Kernel#set_immediate(&block)
  + Executes the given block
  + Is aliased as next_tick


SUCCESS [0 failed, 0 skipped, 6 total]
