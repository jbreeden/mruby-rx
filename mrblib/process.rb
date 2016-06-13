module Rx
module Process
  module Private # :nodoc: all
    def self.translate_signal(signal)
      as_sym, as_str = case signal
      when String
        [signal.upcase.to_sym, signal.upcase]
      when Symbol
        [signal.upcase, signal.upcase.to_s]
      when Fixnum
        # Short-circuit
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
      else
        raise ArgumentError.new("Unrecognized signal #{signal}")
      end
    end
  end

  # :args: a, b
  # Invoke `block` on the next cycle of the event loop
  def self.next_tick(*args, &block)
    Rx.next_tick(*args, &block)
  end

  # Registers the given block as an event handler for `signal`.
  #
  # - `signal` may be a Symbol, String, or Fixnum and is case insensitive. (Examples: `'SIGINT'`, `:sigint`, `2`)
  # - `listener` a block to be invoked on receipt of `signal`.
  def self.on(signal, &listener)
    handle = UV::Signal.new
    signal = Private.translate_signal(signal)
    UV.signal_init(Rx.default_loop, handle)
    UV.unref(handle)
    UV.signal_start(handle, signal) do
      listener[]
    end
  end

  # The path to the currect executable
  def self.exec_path
    UV.exepath
  end
  class << self
    alias execPath exec_path
  end
end
end
