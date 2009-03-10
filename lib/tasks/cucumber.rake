$:.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
require 'cucumber/rake/task'

task :features => 'features:all'
task :features => 'db:test:prepare'

out = ENV['CC_BUILD_ARTIFACTS'] || "artifacts"
mkdir_p out unless File.directory? out if out

namespace :features do
  Cucumber::Rake::Task.new(:webrat) do |t|
    t.cucumber_opts = "--language es --format pretty --require features/support/env.rb --require features/support/plain.rb"
    t.feature_pattern = "features/plain/*.feature"
    t.step_pattern = "features/step_definitions/*.rb"
  end
  Cucumber::Rake::Task.new(:selenium) do |t|
    t.cucumber_opts = "--language es --format pretty --require features/support/enhanced.rb"
    t.feature_pattern = "features/enhanced/*.feature"
    t.step_pattern = "features/step_definitions/*.rb"
  end
  task :all do
    Rake::Task["features:webrat"].invoke
    Rake::Task["features:selenium"].invoke
  end
  task :cruise => 'features:cruise:all'
  namespace :cruise do
    Cucumber::Rake::Task.new(:webrat) do |t|
      t.cucumber_opts = "--language es --format pretty --out=#{out}/features_plain.txt --format html --out=#{out}/features_plain.html --require features/support/env.rb --require features/support/plain.rb"
      t.feature_pattern = "features/plain/*.feature"
      t.step_pattern = "features/step_definitions/*.rb"
    end
#    Cucumber::Rake::Task.new(:selenium) do |t|
#      t.cucumber_opts = "--language es --format pretty --out=#{out}/features_enhanced.txt --format html --out=#{out}/features_enhanced.html --require features/support/env.rb --require features/support/enhanced.rb"
#      t.feature_pattern = "features/enhanced/*.feature"
#      t.step_pattern = "features/step_definitions/*.rb"
#    end
    task :selenium do
      system "xvfb-run cucumber -p selenium"
    end

    task :all do
      Rake::Task["features:cruise:webrat"].invoke
      Rake::Task["features:cruise:selenium"].invoke
    end
  end
#  Cucumber::Rake::Task.new(:rcov) do |t|
#    t.cucumber_opts = "--language es --format pretty --require features/support/webrat_env.rb"
#    t.feature_pattern = "features/features_plain/*.feature"
#    t.step_pattern = "features/step_definitions/*.rb"
#    t.rcov = true
#    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/}
#    t.rcov_opts << %[-o "coverage/features_with_ajax"]
#  end
end
