require File.dirname(__FILE__) + '/../spec_helper'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. .. lib])
require 'rack/mock'
require 'rack/server_name_parser'
 
describe Rack::ServerNameParser do
  it "should add the server name to the lead params" do
    app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, env["rack.request.form_hash"]]}

    env = Rack::MockRequest.env_for("/leads.xml")
    params = Rack::ServerNameParser.new(app).call(env).last
    params['lead']['website'].should == 'example.org'
  end
end
