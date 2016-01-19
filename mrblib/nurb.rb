module Nurb
  def self.main_loop
    @main_loop ||= UV.uv_default_loop
  end
  
  def self.run(&block)
    block[] if block_given?
    UV.uv_run(main_loop)
  end
  
  module Handle
    include EventEmitter
    
    def close
      UV.uv_close(@handle)
      self.emit('close')
      @handle = nil
    end
    
    def ref
      UV.uv_ref(@handle)
    end
    
    def unref
      UV.uv_unref(@handle)
    end
  end
end
