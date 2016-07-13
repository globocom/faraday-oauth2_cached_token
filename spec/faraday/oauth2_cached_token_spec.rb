require 'faraday'

require 'faraday/oauth2_cached_token'
require 'faraday/oauth2_cached_token/provider'
require 'faraday/oauth2_cached_token/token'

module Faraday
  describe OAuth2CachedToken do
    describe '#new' do
      subject { OAuth2CachedToken.new(double, options) }

      describe 'when provider option is passed' do
        let(:provider) { double OAuth2CachedToken::Provider }
        let(:options) do
          { provider: provider }
        end

        it 'uses it as the provider' do
          expect(subject.provider).to eq(provider)
        end
      end

      describe 'when provider option is not passed' do
        let(:provider_options) do
          { store: double }
        end
        let(:options) do
          { provider_options: provider_options }
        end

        it 'constructs a new Provider with passed provider_options' do
          expect(OAuth2CachedToken::Provider).to receive(:new).with(provider_options)
          subject
        end
      end
    end

    describe 'when token is unauthorized' do
      let(:url) { 'http://fake_site/token' }
      let(:old_token) { OAuth2CachedToken::Token.new('old_token', expires_in) }
      let(:fresh_token) { OAuth2CachedToken::Token.new('fresh_token', expires_in) }
      let(:expires_in) { Time.at(5 * 60) }
      let(:provider) do
        OAuth2CachedToken::Provider.new({
          id: 'fake_id',
          secret: 'fake_secret',
          options: {
            site: 'http://fake_site',
            token_url: '/token'
          }
        })
      end

      let(:stubs) do
        Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get(url, { 'Authorization' => 'Bearer old_token' }) { |env| [401] }
          stub.get(url, { 'Authorization' => 'Bearer fresh_token' }) { |env| [200] }
        end
      end

      let(:conn) do
        Faraday.new url do |faraday|
          faraday.request :oauth2_cached_token, provider: provider
          faraday.adapter :test do |stub|
            stub.get(url, { 'Authorization' => 'Bearer old_token' }) { |env| [401] }
            stub.get(url, { 'Authorization' => 'Bearer fresh_token' }) { |env| [200] }
          end
        end
      end

      before do
        Faraday::Request.register_middleware oauth2_cached_token: OAuth2CachedToken
        allow(provider).to receive(:get_token).and_return(old_token, expires_in)
        allow(provider).to receive(:get_fresh_token).and_return(fresh_token, expires_in)
      end

      it 'refreshes the token' do
        expect(conn.get.env.request_headers['Authorization']).to eq('Bearer fresh_token')
      end
    end
  end
end
