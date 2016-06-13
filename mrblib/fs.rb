module Rx
module FS
  # TODO: Should always use canonical version for path comparisons

  # # Events
  # - `'change'`: Emitted as `self.emit('change', cur, prev)` where `cur` and `prev`
  #           contain the current and previous file metadata.
  # - `'error'`: Emitted as `self.emit('error', status)` where `status` is a numerical
  #              error code.
  class PollingWatcher
    include EventEmitter

    def initialize(path, options={}, &block)
      raise ArgumentError.new("Block required") unless block_given?
      options = ({:persistent => true, :interval => 5007}).merge(options)
      @handle = UV::FSPoll.new
      @path = path
      @listeners = []
      self.add_listener('change', &block)
      UV.fs_poll_init(Rx.default_loop, @handle)
      UV.unref(@handle) unless options[:persistent]
      UV.fs_poll_start(@handle, path, options[:interval]) do |handle, status, prev, cur|
        if status == 0
          # swapped cur & prev to match Node
          self.emit('change', cur, prev)
        else
          self.emit('error', status)
        end
      end
    end

    # Closes the underlying file watch handle provided by libuv
    def close
      UV.fs_poll_stop(@handle)
    end

    private

    attr_reader :listeners
  end

  # Alias for PollingWatcher::new.
  def self.watch_file(path, options={}, &block)
    PollingWatcher.new(path, options, &block)
  end
end
end
