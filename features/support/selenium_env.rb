# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures

# Comment out the next line if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
require 'spec'
require 'selenium'
require 'webrat'
require 'webrat/selenium'

# this won't be needed in the next release
module Cucumber::StepMethods
  alias_method :Dado, :Given
  alias_method :Cuando, :When
  alias_method :Entonces, :Then
end

Before do
  @browser = Selenium::SeleniumDriver.new("localhost", 4444, "*chrome", "http://localhost", 15000)
  @browser.start
end
 
After do
  @browser.stop
end

#module ActionController
# module Integration
#   class Session
#     def response
#omething       webrat_session.response
#     end
#   protected
#     def webrat_session
#       @webrat_session ||= selenium_session #false
##Webrat::RailsSession.new(self)
#     end
#     def selenium_session
#       Webrat::SeleniumSession.new($selenium_driver)
#     end
#   end
# end
#end
