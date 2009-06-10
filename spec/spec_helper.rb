ENV['RACK_ENV'] = "test"
require 'rubygems'
require 'spec'
require 'spec/interop/test'
require 'sinatra/test'
require File.join(File.dirname(__FILE__), '..', 'app', 'app.rb')

 
Spec::Runner.configure do |config|
  config.before(:each) { @app = NewApp }
  config.include Sinatra::Test
end