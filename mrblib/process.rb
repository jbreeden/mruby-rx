module Nurb
module Process
  module Private
    def self.translate_signal(signal)
      as_sym, as_str = case signal
      when String
        [signal.to_sym, signal]
      when Symbol
        [signal, signal.to_s]
      when Fixnum
        return signal
      else
        raise ArgumentError.new("Expected signal to be a string, symbol, or fixnum.")
      end
      
      if as_str.start_with?('SIG') && UV.const_defined?(as_sym)
        const = UV.const_get(as_sym)
        if const.kind_of?(Fixnum)
          return const
        else
          raise ArgumentError.new("Unrecognized signal #{signal}")
        end
      end
    end
  end
  
  def self.on(signal, &listener)
    handle = UV::UvSignalT.new
    signal = Private.translate_signal(signal)
    UV.uv_signal_init(Nurb.main_loop, handle)
    UV.uv_unref(handle)
    UV.uv_signal_start(handle, signal) do
      listener[]
    end
  end
  
  def self.execPath
    UV.uv_exepath
  end
end
end
