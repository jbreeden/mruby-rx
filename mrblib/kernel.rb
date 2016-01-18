module Kernel
  def set_timeout(*args, &block)
    Nurb.set_timeout(*args, &block)
  end
  
  def set_interval(*args, &block)
    Nurb.set_interval(*args, &block)
  end
  
  def clear_timeout(*args, &block)
    Nurb.clear_timeout(*args, &block)
  end
  
  def clear_interval(*args, &block)
    Nurb.clear_interval(*args, &block)
  end
end
