Rx.run do
  observable = Rx::Observable.new { |obs|
    i = 0
    interval = Rx.set_interval(10) {
      obs.next(i)
      i += 1
      if i == 5
        Rx.clear_interval(interval)
        obs.complete
      end
    }
  }

  observable.subscribe(
    next: proc { |val| puts "Got #{val}" },
    complete: proc { puts "COMPLETE!" }
  )
end
