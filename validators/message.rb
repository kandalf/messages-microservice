require 'scrivener'

module Validators
  class Message < Scrivener
    attr_accessor :body, :language, :country

    def validate
      assert_present(:body)
      assert_present(:language)
    end
  end
end
