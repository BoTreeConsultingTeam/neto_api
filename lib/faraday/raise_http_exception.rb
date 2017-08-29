require 'faraday'
require 'neto_api/errors'

module FaradayMiddleware
  class RaiseHttpException < Faraday::Response::Middleware
    ServerErrorStatuses = 400...600

    def on_complete(env)
      case env[:status]
      when 400
        raise NetoApi::BadRequestError, response_values(env)
      when 403
        raise NetoApi::UnauthorizedError, response_values(env)
      when 404
        raise NetoApi::ResourceNotFoundError, response_values(env)
      when 407
        # mimic the behavior that we get with proxy requests with HTTPS
        raise Faraday::Error::ConnectionFailed, %{407 "Proxy Authentication Required "}
      when ServerErrorStatuses
        raise NetoApi::InternalServerError, response_values(env)
      end
    end

    def response_values(env)
      {:status => env.status, :headers => env.response_headers, :body => env.body}.to_json
    end
  end
end