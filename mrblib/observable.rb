module Rx
  class Observable
    attr_reader :source, :generator

    # Create a new observable with an optional `source` Observable
    # and a required `generator` function.
    def initialize(source=nil, &generator)
      raise "Generator block expected" if generator.nil?
      @source = source
      @generator = generator
    end

    # "Activates" an event stream by calling the generator function
    # with the given observer. Note that observables may be chained
    # by subscribing to existing observables from within the generator
    # function.
    def subscribe(_next=nil, error=nil, complete=nil, &block)
      generate(Observer.create(_next, error, complete, &block)) # may return disposable
    end

    # Invokes the generator proc the observable was created with,
    # passing in the provided `observer` argument, and setting the
    # context for `self` to this observable. (Called by #subscribe)
    def generate(observer)
      self.instance_exec(observer, &@generator) # may return disposable
    end

    # Create a new observable, with this observable as the source.
    # A generator function is provided that subscribes to this source observable.
    # On subscription, `observerAdapter` is call with the client's Observer,
    # and should return an Observer. The provides a middleware mechanism,
    # useful for implementing operators. The advantage to standardizing on
    # `lift` is that a Subclass my override `lift` to specialize the Observable
    # subclass that is used. In this way, custom Observable subclasses may
    # be implemented that naturally compose through operators. This could be used
    # to decorate all created observables with event logging, for example.
    def lift(observerAdapter)
      return Observable.new(self) { |observer|
        this.source.subscribe(observerAdapter.call(observer)) # may return disposable
      }
    end
  end
end
