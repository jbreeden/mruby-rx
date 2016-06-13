module Rx
  # Returns an Observable that polls `path` for changes and invokes
  # Observer#next on it's observers with two arguments: `current` and `previous`,
  # which are both file stat objects.
  def self.poll_file(path, options={})
    Observable.new() do |observer|
      options = ({:persistent => true, :interval => 5007}).merge(options)
      handle = UV::FSPoll.new
      path = path

      UV.fs_poll_init(Rx.default_loop, handle)
      UV.unref(handle) unless options[:persistent]
      UV.fs_poll_start(handle, path, options[:interval]) do |handle, status, prev, cur|
        if status == 0
          observer.next(Change.new(prev, cur))
        else
          err = UV.errno_to_error(status)
          observer.error(err)
        end
      end

      # Closes the underlying file watch handle provided by libuv
      Disposable.new() { UV.fs_poll_stop(handle) }
    end
  end

  def self.watch_file(path, flags=0)
    unless flags == UV::FS_EVENT_RECURSIVE || flags == 0
      raise "Unrecognized flags: #{flags}"
    end

    Observable.new { |observer|
      handle = UV::FSEvent.new
      UV.fs_event_init(main_loop, handle)

      callback = proc do |handle, path, events, status|
        if status == 0
          observer.next(events) # bit flags
        else
          observer.error(UV.errno_to_error(status))
        end
      end

      UV.fs_event_start(handle, path, 0, &callback)

      Disposable.new() { UV.fs_event_stop(handle) }
    }
  end
end
