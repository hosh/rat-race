desc "Task for a real spec"
task :real_spec do  
  require 'metric_fu'
  RAILS_ENV = ENV['RACK_ENV'] = 'test' # Without this, it will drop your production database
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['spec'].invoke
end