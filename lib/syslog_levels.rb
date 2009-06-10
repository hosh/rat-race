module SyslogLevels
  
  require 'syslog'
  include Syslog::Constants

    #this is all we care about:
    #define LOG_EMERG	0
    #define	LOG_ALERT	1
    #define	LOG_CRIT	2
    #define	LOG_ERR		3
    #define	LOG_WARNING	4
    #define	LOG_NOTICE	5
    #define	LOG_INFO	6
    #define	LOG_DEBUG	7
    
    LOG_LEVELS = %w[LOG_EMERG LOG_ALERT LOG_CRIT LOG_ERR 
      LOG_WARNING LOG_NOTICE LOG_INFO LOG_DEBUG]
    
    def get_level_name(index)
      LOG_LEVELS[index]
    end
    
    def get_level_index(name)
        LOG_LEVELS.index(name)
    end

end