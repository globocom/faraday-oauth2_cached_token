$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'faraday-oauth2_cached_token'
  s.version     = '0.1.0'
  s.authors     = ['Rodrigo Willrich', 'Jean Carlo Emer', 'Pablo Machado']
  s.email       = ['rodrigo.willrich@corp.globo.com', 'jean.emer@corp.globo.com', 'pablo.machado@corp.globo.com']
  s.homepage    = 'http://github.com/globocom/faraday-oauth2_cached_token'
  s.summary     = 'Middleware to handle OAuth2 token caching'
  s.description = 'Faraday middleware that caches and refreshes OAuth2 tokens as needed'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_runtime_dependency 'faraday', '~> 0'
  s.add_runtime_dependency 'oauth2', '~> 0'
  s.add_runtime_dependency 'activesupport', '~> 0'
end
