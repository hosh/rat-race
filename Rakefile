require 'rubygems'
require 'rake'
require 'date'
require 'spec/rake/spectask'
require 'activerecord'

# load 'lib/tasks/database.rake'

Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rake"].sort.each { |ext| load ext }

desc "Loads the app environment"
task :environment do  
  if ENV['RACK_ENV'].nil? && ENV['RAILS_ENV']
    ENV['RACK_ENV'] = ENV['RAILS_ENV']
  end
  RACK_ENV = (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : 'development').to_s
end

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end

begin
  require 'metric_fu'
rescue LoadError
  puts 'Failed to load metric_fu gem. Install if you want metric reports.'
end

task :default => :spec