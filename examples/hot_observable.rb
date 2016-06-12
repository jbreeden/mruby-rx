class HotListObservable
  attr_reader :subscribers

  def initialize(list)
    @subscribers = []
    @source = Rx::Observable.new() do |observer|
      list = list.dup
      interval = set_interval(10) do
        observer.next(list.shift)
        if list.empty?
          clear_interval(interval)
          observer.complete
        end
      end
    end

    # Immediately start source observable with an observer
    # that calls any active subscribers on this "hot" observable
    @source.subscribe(Rx::Observer.create(
      next: proc { |val| self.subscribers.each { |sub| sub.next(val) }},
      error: proc { |val| self.subscribers.each { |sub| sub.error(val) }},
      complete: proc { self.subscribers.each { |sub| sub.complete }}
    ))
  end

  def subscribe(*args)
    observer = Rx::Observer.create(*args)
    @subscribers.push(observer)
    Rx::Disposable.new {
      @subscribers.delete(observer)
    }
  end
end

Rx.run do
  hot_observable = HotListObservable.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

  subscription_1 = hot_observable.subscribe(
    next: ->(val) { puts "Subscriber 1 got: #{val}"}
  )
  set_timeout(50) { subscription_1.dispose }

  subscription_2 = hot_observable.subscribe(
    next: ->(val) { puts "Subscriber 2 got: #{val}"},
    complete: -> { puts 'COMPLETE!' }
  )
end
