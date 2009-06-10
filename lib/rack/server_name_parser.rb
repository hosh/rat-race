require 'yaml'

module Rack
  class ServerNameParser
    SERVER_NAME = 'SERVER_NAME'.freeze
    FORM_INPUT = 'rack.request.form_input'.freeze
    FORM_HASH = 'rack.request.form_hash'.freeze

    # Supported Content-Types
    #
    APPLICATION_XML = 'application/xml'.freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      env[FORM_HASH] ||= {}
      env[FORM_HASH]["lead"] ||= {}
      env[FORM_HASH]["lead"]["website"] = env[SERVER_NAME]
      @app.call(env)
    end

  end
end

