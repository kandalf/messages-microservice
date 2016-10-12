require 'scrivener'

module Validators
  class Search < Scrivener
    attr_accessor :language, :limit

    MAX_RESULTS = 20

    def validate
      if limit
        if assert(limit.to_i > 0, [:limit, :not_valid])
          self.limit = MAX_RESULTS if limit.to_i > MAX_RESULTS
        end
      end

      if language
        if language.empty? || language == "all"
          self.language = "%"
        end
      end
    end
  end
end
