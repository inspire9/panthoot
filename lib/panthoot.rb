require 'hashie'

module Panthoot
  def self.configure
    yield self
  end

  def self.listener
    @listener
  end

  def self.listener=(listener)
    @listener = listener
  end
end

require 'panthoot/app'
require 'panthoot/data'
require 'panthoot/translator'

require 'panthoot/engine' if defined?(Rails)
