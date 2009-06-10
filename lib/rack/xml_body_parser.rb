module Rack
class XMLBodyParser
  require 'rubygems'
  require 'active_support/core_ext/hash/conversions'
  
  CONTENT_TYPE = 'CONTENT_TYPE'.freeze
  POST_BODY = 'rack.input'.freeze
  FORM_INPUT = 'rack.request.form_input'.freeze
  FORM_HASH = 'rack.request.form_hash'.freeze
  
  # Supported Content-Types
  #
  APPLICATION_XML = 'application/xml'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    body = env[POST_BODY]
    case env[CONTENT_TYPE]
    when APPLICATION_XML
      env.update(FORM_HASH => Hash.from_xml(body.read), FORM_INPUT => body)
    end
    @app.call(env)
  end

end
end