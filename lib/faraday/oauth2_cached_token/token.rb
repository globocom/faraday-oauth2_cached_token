require 'faraday'

module Faraday
  class OAuth2CachedToken < Middleware
    class Token
      attr_reader :expires_in

      def initialize(token, expires_in)
        @token = token
        @expires_in = expires_in
      end

      def headers
        {'Authorization' => "Bearer #{@token}"}
      end

      def self.from_access_token(access_token)
        new(access_token.token, access_token.expires_in)
      end
    end
  end
end
