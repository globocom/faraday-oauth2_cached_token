require 'faraday'
require 'oauth2/client'
require 'active_support'

require 'faraday/oauth2_cached_token/token'

module Faraday
  class OAuth2CachedToken < Middleware
    class Provider
      def initialize(options)
        @options = options
        @cache = options[:store] || ActiveSupport::Cache::MemoryStore.new
      end

      def get_fresh_token
        token = Token.from_access_token(oauth2_client.client_credentials.get_token)
        @cache.write(cache_key, token, expires_in: token.expires_in)
        token
      end

      def get_token
        @cache.read(cache_key) || get_fresh_token
      end

      private

      def cache_key
        "oauth2_cached_token_#{@options[:id]}"
      end

      private

      def oauth2_client
        OAuth2::Client.new(@options[:id], @options[:secret], @options[:options])
      end
    end
  end
end
