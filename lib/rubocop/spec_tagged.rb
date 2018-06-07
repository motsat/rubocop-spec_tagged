require 'rubocop'
require "rubocop/spec_tagged/version"
require 'rubocop/spec_tagged/inject'

RuboCop::SpecTagged::Inject.defaults!

# cops
require 'rubocop/cop/lint/spec_tagged'

module Rubocop
  module SpecTagged
    # Your code goes here...
  end
end
