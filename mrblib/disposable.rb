module Rx
  class Disposable
    def initialize(&action)
      @action = action
    end

    def dispose
      @action.call()
    end
  end
end
