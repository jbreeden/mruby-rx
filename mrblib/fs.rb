module Nurb
module FS
  # TODO: Should always use canonical version for path comparisons
  
  class PollingWatcher
    include EventEmitter
    
    attr_reader :listeners
    def initialize(path, options={}, &block)
      raise ArgumentError.new("Block required") unless block_given?
      options = ({:persistent => true, :interval => 5007}).merge(options)
      @handle = UV::UvFsPollT.new
      @path = path
      @listeners = []
      self.add_listener('change', &block)
      UV.uv_fs_poll_init(Nurb.main_loop, @handle)
      UV.uv_unref(@handle) unless options[:persistent]
      UV.uv_fs_poll_start(@handle, path, options[:interval]) do |handle, status, prev, cur|
        if status == 0
          # swapped cur & prev to match Node
          self.emit('change', cur, prev)
        else
          self.emit('error', status)
        end
      end
    end
    
    def close
      UV.uv_fs_poll_stop(@handle)
    end
  end
  
  def self.watch_file(path, options={}, &block)
    PollingWatcher.new(path, options, &block)
  end
end
end
