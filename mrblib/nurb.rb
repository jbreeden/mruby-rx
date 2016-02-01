module Nurb
  def self.default_loop
    # Get a fresh loop for this mruby context
    # (Future-proofing for multiple mrb's in one application)
    @default_loop ||= UV::Loop.new
  end
  
  def self.run(&block)
    block[] if block_given?
    UV.run(default_loop)
  end
  class << self
    alias start run
  end
  
  def self.stop(loop = default_loop)
    UV.close(default_loop)
  end
  
  module Handle
    include EventEmitter
    
    def close
      UV.close(@handle)
      self.emit('close')
      @handle = nil
    end
    
    def ref
      UV.ref(@handle)
    end
    
    def unref
      UV.unref(@handle)
    end
  end
end
