rspec_base = File.expand_path("#{RAILS_ROOT}/vendor/plugins/rspec/lib")
$LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

RCov::VerifyTask.new(:verify_rcov) { |t| t.threshold = 100.0 }

desc "Task for cruise Control"
task :custom do
  out = ENV['CC_BUILD_ARTIFACTS']
  mkdir_p out unless File.directory? out if out

  CruiseControl::invoke_rake_task 'db:migrate'
  CruiseControl::invoke_rake_task 'cruise'
end

desc "Run specs and rcov"
Spec::Rake::SpecTask.new(:cruise_coverage) do |t|
  t.rcov_dir = ENV['CC_BUILD_ARTIFACTS'] || 'coverage'
  t.spec_opts = ['--options', "#{RAILS_ROOT}/spec/spec_rcov.opts"]
  t.spec_files = FileList['spec/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,/usr/lib/ruby', '--rails', '--text-report']
end


desc 'Continuous build target'
task :cruise do

  #here we should restart the staging server
  #by touching a tmp/restart.txt file to restart passenger
  system "touch tmp/restart.txt"

  RAILS_ENV = ENV['RAILS_ENV'] = 'test' # Without this, it will drop your production (or development) database.

  # now we prepare the DB for the test environment
  Rake::Task["db:drop"].invoke
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke

  
  out = ENV['CC_BUILD_ARTIFACTS'] || 'artifacts'
  mkdir_p out unless File.directory? out if out

  Rake::Task["test"].invoke
  Rake::Task["spec"].invoke
  Rake::Task["features:cruise"].invoke

end
