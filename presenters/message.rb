module Presenters
  class Message
    def initialize(message)
      @msg = message
    end

    def to_hash
      { message: "#{@msg.body} from #{@msg.country}" } 
    end
  end
end
