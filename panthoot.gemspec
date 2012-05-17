# -*- encoding: utf-8 -*-
require File.expand_path('../lib/panthoot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Pat Allan']
  gem.email         = ['pat@freelancing-gods.com']
  gem.description   = 'Listener for MailChimp callbacks'
  gem.summary       = 'Provides a listener for MailChimp callbacks for Rack/Rails apps'
  gem.homepage      = 'https://github.com/inspire9/panthoot'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = 'panthoot'
  gem.require_paths = ['lib']
  gem.version       = Panthoot::VERSION

  gem.add_runtime_dependency 'hashie', '1.2.0'

  gem.add_development_dependency 'rails',       '3.2.2'
  gem.add_development_dependency 'rspec-rails', '2.10.1'
end
