
Nurb Timers
-----------

- set_timeout(delay, &block)
  + Runs `block` after `delay` milliseconds

- clear_timeout(timeout)
  + Cancels the timeout returned by set_timeout

- set_interval(delay, &block)
  + Runs `block` after every `delay` milliseconds

- clear_interval(interval)
  + Cancels the interval returned by set_interval

- set_immediate(&block)
  + Executes the given block
  + Is aliased as next_tick


SUCCESS [0 failed, 0 pending, 6 total]
