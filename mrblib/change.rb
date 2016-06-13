module Rx
  # Represents a change. Has two fields: #previous and #current
  class Change
    attr_reader :previous, :current

    def initialize(prev, cur)
      @previous = prev
      @current = cur
    end
  end
end
