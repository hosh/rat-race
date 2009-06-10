require 'rubygems'
require 'syslog_logger'
# You can install this syslog logger by getting it from github at:
#
# http://github.com/cpowell/sysloglogger/tree/master
# sudo gem install cpowell-SyslogLogger
#
# This implementations configuration example in /etc/syslog.conf
#
# Example:
# --------------------------------------------------------------------------------
# !service_leads
# *.*                                             /var/log/service_leads.log
#
### ng setup
# destination service_leads_log { file("/var/log/service_leads.log"); };
# filter f_service_leads { program("service_leads.*"); };
# log { source(src); filter(f_service_leads); destination(service_leads_log); };

class SyslogLogger
  def <<(data)
    add(1, data)
  end
end

module Rack
  class CombinedLogger < CommonLogger
    def each
      length = 0
      @body.each { |part|
        length += part.size
        yield part
      }

      @now = Time.now

      # Combined Log Format: http://httpd.apache.org/docs/1.3/logs.html
      # lilith.local - - [07/Aug/2006 23:58:02] "GET / HTTP/1.1" 500 -
      #             %{%s - %s [%s] "%s %s%s %s" %d %s\n} %
      @logger << %{%s - %s [%s] "%s %s%s %s" %d %s "%s" "%s" %0.4f\n} %
        [
         @env['HTTP_X_FORWARDED_FOR'] || @env["REMOTE_ADDR"] || "-",
         @env["REMOTE_USER"] || "-",
         @now.strftime("%d/%b/%Y %H:%M:%S"),
         @env["REQUEST_METHOD"],
         @env["PATH_INFO"],
         @env["QUERY_STRING"].empty? ? "" : "?"+@env["QUERY_STRING"],
         @env["HTTP_VERSION"],
         @status.to_s[0..3],
         (length.zero? ? "-" : length.to_s),
         @env["HTTP_REFERER"],
         @env["HTTP_USER_AGENT"], 
         @now - @time
        ]
      unless @env['rack.request.form_hash'].empty?
      @logger << %{%s\n} %
        [
          @env['rack.request.form_hash'].inspect
        ]
      end
    end
  end
end