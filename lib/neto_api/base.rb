module NetoApi
  class Base
    END_POINT = '/do/WS/NetoAPI'.freeze

    attr_reader :store_url, :api_key, :options

    def initialize(store_url, api_key, options = {})
      @store_url = store_url
      @api_key = api_key
      @options = options
    end

    private

    NETOAPI_ACTION_HEADER = 'NETOAPI_ACTION'.freeze

    def connection(action)
      options.merge!(headers: { NETOAPI_ACTION_HEADER => action })
      @connection ||= NetoApi::Client.new(store_url, api_key, options).connection
    end

    def end_point
      END_POINT
    end

    def post(action, body)
      connection(action).post(END_POINT, body)
    end
  end
end