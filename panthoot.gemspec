# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = 'panthoot'
  gem.authors       = ['Pat Allan']
  gem.email         = ['pat@freelancing-gods.com']
  gem.summary       = 'ActiveSupport::Notifications for MailChimp callbacks'
  gem.description   = 'Provides an Rack/Rails API endpoint for MailChimp callbacks with corresponding ActiveSupport::Notifications.'
  gem.homepage      = 'https://github.com/inspire9/panthoot'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.require_paths = ['lib']
  gem.version       = '0.1.0'

  gem.add_runtime_dependency 'hashie', '1.2.0'

  gem.add_development_dependency 'combustion',  '~> 0.5.0'
  gem.add_development_dependency 'rails',       '~> 3.2.13'
  gem.add_development_dependency 'rspec-rails', '~> 2.13.2'
end
