require "json"

module MessageService
  module Helpers
    def format_json(object)
      res.headers["Content-Type"] = "application/json; charset=UTF-8"

      res.write Oj.dump(object)

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

    def unprocessable!(message: "Unprocessable Entity", errors: {})
      res.status = 422

      format_json(message: message, errors: errors)
    end

    def not_found!
      res.status = 404

      format_json(message: "Not Found")
    end

    def success!(body)
      res.status = 200

      format_json(body)
    end

    def bad_request!(message = "Bad Request")
      res.status = 400

      format_json(message: message)
    end
  end
end
