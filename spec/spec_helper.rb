require 'bundler'

Bundler.setup :default, :development

require 'rails'
require 'combustion'
require 'panthoot'

Combustion.initialize! :action_controller

require 'rspec/rails'
