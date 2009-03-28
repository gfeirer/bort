ENV["RAILS_ENV"] = "test" 
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatters/unicode'
require 'webrat/rails'
require 'cucumber/rails/rspec'

module Cucumber::StepMethods
  alias_method :Dado, :Given
  alias_method :Cuando, :When
  alias_method :Entonces, :Then
end
