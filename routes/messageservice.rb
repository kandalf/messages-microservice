module Routes
  class MessageService < Cuba
    define do
      on root do
        on post do
          bad_request! unless json_request?

          params = {}.tap do |hash|
            hash["language"] = req.params["lang"].to_s.empty? ? req.env["rack.language"] : req.params["lang"]
            hash["country"]  = req.env["rack.geo_data"][:country_name]
            hash["body"]     = req.params["message"]
            hash
          end

          validator = Validators::Message.new(params)

          unprocessable!(errors: validator.errors) unless validator.valid?

          message = Message.create(validator.attributes)

          created!(Presenters::Message.new(message))
        end
      end
    end
  end
end
