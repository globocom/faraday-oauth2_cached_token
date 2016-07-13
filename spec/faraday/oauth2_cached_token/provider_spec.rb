require 'oauth2'
require 'active_support/cache'

require 'faraday/oauth2_cached_token/provider'
require 'faraday/oauth2_cached_token/token'

module Faraday
  describe OAuth2CachedToken::Provider do
    let(:store) { double ActiveSupport::Cache::MemoryStore }
    let(:options) do
      {
        id: 'fake_id',
        secret: 'fake_secret',
        options: {
          site: 'http://fake_site',
          token_url: '/fake_token'
        },
        store: store
      }
    end

    subject { described_class.new(options) }

    describe '#get_fresh_token' do
      let(:token) { 'fake_token' }
      let(:expires_in) { Time.at(5 * 60) }

      let(:oauth2_client) { double OAuth2::Client }
      let(:client_credentials) { double OAuth2::Strategy::ClientCredentials }
      let(:access_token) { double OAuth2::AccessToken }

      before do
        allow(OAuth2::Client).to receive(:new).with(
          options[:id],
          options[:secret],
          options[:options]
        ).and_return(oauth2_client)
        allow(oauth2_client).to receive(:client_credentials).and_return(client_credentials)
        allow(access_token).to receive(:token).and_return(token)
        allow(access_token).to receive(:expires_in).and_return(expires_in)
        allow(client_credentials).to receive(:get_token).and_return(access_token)
        allow(store).to receive(:write)
      end

      it 'calls OAuth2 client and returns a OAuth2CachedToken::Token' do
        expect(OAuth2::Client).to receive(:new).with(
          options[:id],
          options[:secret],
          options[:options]
        )
        token = subject.get_fresh_token
        expect(token).to be_an_instance_of(OAuth2CachedToken::Token)
        expect(token.headers).to eq({ 'Authorization' => 'Bearer fake_token' })
      end

      it 'caches token with correct id cache key and expires' do
        expect(store).to receive(:write).with(
          'oauth2_cached_token_fake_id',
          instance_of(OAuth2CachedToken::Token),
          expires_in: expires_in
        )
        subject.get_fresh_token
      end
    end

    describe '#get_token' do
      let(:fresh_token) { double OAuth2CachedToken::Token }
      let(:cached_token) { double OAuth2CachedToken::Token }

      before do
        allow(subject).to receive(:get_fresh_token).and_return(fresh_token)
      end

      describe 'when token is cached' do
        before do
          allow(store).to receive(:read).and_return(cached_token)
        end

        it 'returns cached token' do
          expect(subject.get_token).to eq(cached_token)
        end

        it 'does not calls get_fresh_token' do
          expect(subject).to_not receive(:get_fresh_token)
          subject.get_token
        end
      end

      describe 'when token is not cached' do
        before do
          allow(store).to receive(:read).and_return(nil)
        end

        it 'returns fresh token' do
          expect(subject.get_token).to eq(fresh_token)
        end

        it 'calls get_fresh_token' do
          expect(subject).to receive(:get_fresh_token)
          subject.get_token
        end
      end
    end
  end
end
