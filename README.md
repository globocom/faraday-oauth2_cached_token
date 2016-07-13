# OAuth2CachedToken middleware

Faraday middleware that caches and refreshes OAuth2 tokens as needed

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday-oauth2_cached_token'
```

## Usage

```ruby
conn = Faraday.new(:url => 'http://sushi.com') do |faraday|
  # You can pass the provider options
  faraday.request :oauth2_cached_token, provider_options: {
    id: 'client_id',
    secret: 'secret',
    options: {
      site: 'http://sushi.com',
      token_url: '/token'
    }
  }

  # Or you can construct a provider yourself
  faraday.request :oauth2_cached_token, provider: Faraday::OAuth2CachedToken::Provider.new({
    id: 'client_id',
    secret: 'secret',
    options: {
      site: 'http://sushi.com',
      token_url: '/token'
    }
  })
  
  faraday.adapter Faraday.default_adapter
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
