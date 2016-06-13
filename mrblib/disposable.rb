module Rx
  class Disposable
    # Creates a disposable that will invoke the `action` block
    # when dispose is called.
    def initialize(&action)
      @action = action
    end

    # Invokes the action this disposable was created with.
    def dispose
      @action.call()
    end
  end
end
