module Kernel
  def set_timeout(*args, &block)
    Rx.set_timeout(*args, &block)
  end

  def set_interval(*args, &block)
    Rx.set_interval(*args, &block)
  end

  def set_immediate(*args, &block)
    Rx.set_immediate(*args, &block)
  end

  def clear_timeout(*args, &block)
    Rx.clear_timeout(*args, &block)
  end

  def clear_interval(*args, &block)
    Rx.clear_interval(*args, &block)
  end

  def next_tick(*args, &block)
    Rx::Process.next_tick(*args, &block)
  end
end
