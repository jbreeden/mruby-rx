module Rx
  class Observer
    def self.create(_next=nil, error=nil, complete=nil)
      observer = nil

      # Allow block calling convention
      if !(_next || error || complete) && block_given?
        observer = Observer.new(proc { |val| yield val })
      # Allow hash calling convention
      elsif _next.kind_of?(Hash)
        observer = Observer.new(
          _next[:next] || _next['next'],
          _next[:error] || _next['error'],
          _next[:complete] || _next['complete']
        )
      # Ok, we'll just try duck typing the first argument
      elsif  !_next.nil?
        observer = _next
      # Or maybe just run the stream without adding anymore links in the chain.
      else
        observer = Observer.new # No-op
      end
    end

    def initialize(on_next, on_error, on_complete)
      @on_next = on_next
      @on_error = on_error
      @on_complete = on_complete
    end

    def next(val)
      @on_next.call(val) if @on_next
    end

    def error(reason)
      if @on_error
        @on_error.call(reason)
      else
        raise reason
      end
    end

    def complete
      @on_complete.call() if @on_complete
    end
  end
end
