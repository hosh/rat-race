# rspec_base = File.expand_path("#{RAILS_ROOT}/vendor/plugins/rspec/lib")
# $LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)
# require 'spec/rake/spectask'
# require 'spec/rake/verify_rcov'
# RCov::VerifyTask.new(:verify_rcov) { |t| t.threshold = 100.0 }

desc "Task for cruise Control"
task :cruise do  
  require 'metric_fu'
  RAILS_ENV = ENV['RACK_ENV'] = 'test' # Without this, it will drop your production database
  CruiseControl::invoke_rake_task 'db:drop'
  CruiseControl::invoke_rake_task 'db:create'
  CruiseControl::invoke_rake_task 'db:migrate'
  CruiseControl::invoke_rake_task 'spec' 
end
