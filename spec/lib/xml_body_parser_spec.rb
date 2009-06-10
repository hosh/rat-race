require File.dirname(__FILE__) + '/../spec_helper'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. .. lib])
require 'rack/mock'
require 'rack/xml_body_parser'

describe Rack::XMLBodyParser do
  it "should handle requests with POST body Content-Type of application/xml" do
    app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, Rack::Request.new(env).POST] }
    xml = "<body>asdf</body>"
    env = env_for_post_with_headers('/', {'Content_Type'.upcase => 'application/xml'}, xml)
    body = Rack::XMLBodyParser.new(app).call(env).last
    body['body'].should == "asdf"
  end

  it "should not handle requests with POST body Content-Type of text.plain" do
    app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, Rack::Request.new(env).POST] }
    xml = "<body>asdf</body>"
    env = env_for_post_with_headers('/', {'Content_Type'.upcase => 'text/plain'}, xml)
    body = Rack::XMLBodyParser.new(app).call(env).last
    body['body'].should be_nil
  end
end

def env_for_post_with_headers(path, headers, body)
  Rack::MockRequest.env_for(path, {:method => "POST", :input => body}.merge(headers))
end
private :env_for_post_with_headers
