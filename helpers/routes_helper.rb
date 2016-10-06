require "json"

module MessageService
  module Helpers
    def format_json(resource)
      res.headers["Content-Type"] = "application/json; charset=UTF-8"
      res.write JSON.dump(resource)

      halt(res.finish)
    end

    def json_request?
      !!(req.env["CONTENT_TYPE"] =~ /application\/json/)
    end

    def created!(resource)
      res.status = 201

      res["Location"] = "/messages/#{resource.id}" if resource.respond_to?(:id)

      format_json(resource)
    end

    def response(status:, body:)
      res.status = status

      format_json(body)
    end

    def unprocessable!(message: "Unprocessable Entity", errors: {})
      res.status = 422

      format_json({ message: message, errors: errors })
    end

    def server_error!(message: "Internal Server Error")
      res.status = 500

      format_json({ message: message })
    end

    def not_found!
      res.status = 404

      format_json(message: "Not Found")
    end

    def success!(body)
      res.status = 200

      format_json(body)
    end

    def parse_request
      unprocessable!(message: "Wrong Request Content Type") unless json_request?

      JSON.parse(req.body.read)
    end
  end
end
