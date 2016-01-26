module Nurb
  def self.main_loop
    @main_loop ||= UV.default_loop
  end
  
  def self.run(&block)
    block[] if block_given?
    UV.run(main_loop)
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
