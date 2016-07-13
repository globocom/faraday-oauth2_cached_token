$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'faraday-oauth2_cached_token'
  s.version     = '0.1.0'
  s.authors     = ['Rodrigo Willrich', 'Jean Carlo Emer', 'Pablo Machado']
  s.homepage    = 'http://github.com/globocom/faraday-oauth2_cached_token'
  s.summary     = 'Middleware to handle OAuth2 token caching'
  s.description = 'Faraday middleware that caches and refreshes OAuth2 tokens as needed'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'faraday'
  s.add_dependency 'oauth2'
  s.add_dependency 'activesupport'
end
