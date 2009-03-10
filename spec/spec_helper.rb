# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

include AuthenticatedTestHelper
include AuthenticatedSystem

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
  def login_as_no_role
    @current_user = mock_model(User, :id => 5, :state => 'active')
    controller.stub!(:current_user).and_return(@current_user)
    @current_user.should_receive(:has_role?).with(any_args()).and_return(false)
  end

  def login_as_admin
    @current_user = mock_model(User, :id => 1, :state => 'active', :roles => [Role.find_by_name("admin")])
    controller.stub!(:current_user).and_return(@current_user)
    @current_user.should_receive(:has_role?).at_least(:once).and_return(true)
  end

#  def login_as_directivo
#    @current_user = mock_model(User, :id => 4, :state => 'active', :roles => [Role.create(:name => "directivo")])
#    controller.stub!(:current_user).and_return(@current_user)
#    @current_user.should_receive(:has_role?) do |role|
#      if role == "directivo"
#        true
#      else
#        false
#      end
#    end.at_least(:once)
#  end

  def authenticated
    @current_user = mock_model(User, :id => 1, :state => 'active', :roles => [])
    controller.stub!(:current_user).and_return(@current_user)
  end
end
