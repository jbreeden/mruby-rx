module Rx
  def self.default_loop
    # May be set ahead of time if spawning multiple MRuby VM's
    # with their own event loops.
    @default_loop ||= UV.default_loop
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

  # Used to decorate classes with @handle instance variables holding a reference
  # to a handle from mruby-libuv. Adds ref and unref as instance methods, and
  # emit's the `'close'` event when the handle is closed.
  module Handle
    include EventEmitter

    # Close the underlying handle from libuv & emit the `'close'` event.
    def close
      UV.close(@handle)
      self.emit('close')
      @handle = nil
    end

    # Increment the reference count between this handle and the event loop.
    # This can be used to keep the event loop alive.
    def ref
      UV.ref(@handle)
    end

    # Decrement the reference count between this handle and the event loop.
    # This can be used to allow the event loop to exit, even if the handle is
    # still active (like a background file watcher).
    def unref
      UV.unref(@handle)
    end
  end
end
