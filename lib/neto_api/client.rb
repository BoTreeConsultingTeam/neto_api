require 'faraday'
require 'faraday_middleware'
require 'logger'
# require 'faraday/detailed_logger'
require 'hashie'
require 'faraday/raise_http_exception'

# require 'activesupport/middleware'

module NetoApi
  class Client
    attr_reader :store_api_url, :api_key, :action, :options
    USER_AGENT = 'dynamiccreative.com ruby client'.freeze

    def initialize(store_api_url, api_key, options = {})
      @store_api_url = store_api_url
      @api_key = api_key
      @options = options
    end

    def connection
      conn = ::Faraday.new(store_api_url, options) do |faraday|
        faraday.request :json
        # faraday.response :logger, ::Logger.new(STDOUT), bodies: true # :detailed_logger
        faraday.response :mashify
        faraday.response :json, :content_type => /\bjson$/
        faraday.use ::FaradayMiddleware::RaiseHttpException
        faraday.adapter Faraday.default_adapter
      end

      # conn.token_auth access_token unless access_token.nil?
      # conn.params['access_token'] = access_token unless access_token.nil?
      conn.headers['User-Agent'] = USER_AGENT
      conn.headers['NETOAPI_KEY'] = api_key.freeze
      conn.headers['Content-type'] = 'application/json'.freeze
      conn.headers['Accept'] = 'application/json'.freeze
      conn
    end
  end
end