module Nurb
  @timers = {}
  @next_timer = 1
  
  def self.set_timeout(delay, &block)
    raise ArgumentError.new("Block required") unless block_given?
    timer = UV::UvTimerT.new
    UV.uv_timer_init(main_loop, timer)

    td = @next_timer    
    @timers[td] = timer
    @next_timer += 1
    
    UV.uv_timer_start(timer, delay, 0) do
      Nurb.clear_timeout(td)
      block[]
    end
    
    return td
  end
  
  def self.set_interval(interval, &block)
    raise ArgumentError.new("Block required") unless block_given?
    timer = UV::UvTimerT.new
    UV.uv_timer_init(main_loop, timer)
    
    td = @next_timer
    @timers[td] = timer
    @next_timer += 1
    
    UV.uv_timer_start(timer, interval, interval, &block)
    
    return td
  end
  
  def self.next_tick(&block)
    raise ArgumentError.new("Block required") unless block_given?
    idle = UV::UvIdleT.new
    UV.uv_idle_init(main_loop, idle)
    UV.uv_idle_start(idle) do
      UV.uv_idle_stop(idle)
      block[]
    end
  end
  
  def self.clear_timeout(td)
    timer = @timers.delete(td)
    if timer
      UV.uv_timer_stop(timer)
    end
  end
  class << self
    alias clear_interval clear_timeout
  end
end
