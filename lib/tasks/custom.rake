rspec_base = File.expand_path("#{RAILS_ROOT}/vendor/plugins/rspec/lib")
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

CRUISE_TASKS = %w( db:migrate restart_passenger db:test:prepare test spec features:cruise )
RCOV_THRESHOLD = 90

desc "Task for cruise Control"
task :cruise do
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  CRUISE_TASKS.each do |t|
    CruiseControl::invoke_rake_task t
  end
end

desc 'Restart passenger if we are running it'
task :restart_passenger do
  #here we should restart the staging server
  #by touching a tmp/restart.txt file to restart passenger
  system "touch tmp/restart.txt"
end

desc 'Setup test environment'
task :setup_test_env do

  RAILS_ENV = ENV['RAILS_ENV'] = 'test' # Without this, it will drop your production (or development) database.
end
