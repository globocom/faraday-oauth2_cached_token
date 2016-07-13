require 'faraday'

require 'faraday/oauth2_cached_token/provider'

module Faraday
  class OAuth2CachedToken < Middleware
    INVALID_TOKEN_STATUS = 401

    attr_reader :provider

    def initialize(app, options = {})
      super(app)
      @provider = options[:provider] || Provider.new(options[:provider_options] || {})
      @logger = options[:logger]
    end

    def call(request_env)
      inject_header(request_env, @provider.get_token.headers)

      @app.call(request_env).on_complete do |response_env|
        on_complete(request_env, response_env)
      end
    end

    private

    def on_complete(request_env, response_env)
      if response_env.status == INVALID_TOKEN_STATUS
        @logger.try(:warn, 'Invalid Token. refreshing and retrying request...')
        inject_header(request_env, @provider.get_fresh_token.headers)
        @app.call(request_env)
      end
    end

    def inject_header(request_env, header)
      request_env[:request_headers].merge!(header)
    end
  end
end

Faraday::Request.register_middleware oauth2_cached_token: Faraday::OAuth2CachedToken
