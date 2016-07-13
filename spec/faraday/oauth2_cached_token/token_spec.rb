require 'faraday/oauth2_cached_token/token'

module Faraday
  describe OAuth2CachedToken::Token do
    let(:token) { 'fake_token' }
    let(:expires_in) { Time.at(4 * 60) }

    subject { described_class.new(token, expires_in) }

    describe '#headers' do
      it 'returns headers' do
        expect(subject.headers).to eq({ 'Authorization' => 'Bearer fake_token' })
      end
    end

    describe '#from_access_token' do
      let(:access_token) { double }

      subject { described_class.from_access_token(access_token) }

      before do
        allow(access_token).to receive(:token).and_return(token)
        allow(access_token).to receive(:expires_in).and_return(expires_in)
      end

      it 'returns access_token headers' do
        expect(subject.headers).to eq({'Authorization' => 'Bearer fake_token'})
      end
    end
  end
end
