require 'rubygems'
require 'lib/rack/xml_body_parser'
require 'lib/rack/server_name_parser'
require 'lib/rack/primedia_logger'
require 'app/app'

CONFIGURATION = YAML::load(IO.read("config/config.yml"))[NewApp.environment.to_s]
LOGGER = !CONFIGURATION[:syslog_disable] ? SyslogLogger.new(CONFIGURATION[:syslog_name]) : Logger.new("log/new_app.log")

use Rack::CombinedLogger, LOGGER
use Rack::XMLBodyParser
use Rack::ServerNameParser

run NewApp