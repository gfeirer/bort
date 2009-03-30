$LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
require 'cucumber/rake/task'

#output dir
out = ENV['CC_BUILD_ARTIFACTS'] || "artifacts"
mkdir_p out unless File.directory? out if out

begin
  namespace :features do
    Cucumber::Rake::Task.new(:webrat) do |t|
      t.cucumber_opts = "--language es --format pretty --require features/support/env.rb --require features/support/plain.rb"
      t.feature_pattern = "features/plain/*.feature"
      t.step_pattern = "features/step_definitions/*.rb"
    end
    Cucumber::Rake::Task.new(:selenium) do |t|
      t.cucumber_opts = "--language es --format pretty --require features/support/env.rb --require features/support/enhanced.rb"
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
        system "xvfb-run cucumber --language es --format pretty --out=#{out}/features_enhanced.txt --format html --out=#{out}/features_enhanced.html --require features/support/env.rb --require features/support/enhanced.rb --require features/step_definitions features/enhanced"
      end
      task :all do
        Rake::Task["features:cruise:webrat"].invoke
        Rake::Task["features:cruise:selenium"].invoke
      end

    end #cruise
  end #features
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
