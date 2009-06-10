namespace :db do
  task :load_config => :environment do
    require 'active_record'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.configurations = YAML::load(IO.read("config/database.yml"))[RACK_ENV]
  end

  desc "Migrates the database"
  task :migrate => :load_config do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations)
    ActiveRecord::Migration.verbose = true
    version = ENV['VERSION'] && ENV['VERSION'].to_i
    ActiveRecord::Migrator.migrate("db/migrate", version)
  end

  desc "Create the database for the current RACK_ENV"
  task :create => :load_config do
    create_database(ActiveRecord::Base.configurations)
  end

  def create_database(config)
    begin
      if config['adapter'] =~ /sqlite/
        if File.exist?(config['database'])
          $stderr.puts "#{config['database']} already exists"
        else
          begin
            # Create the SQLite database
            ActiveRecord::Base.establish_connection(config)
            ActiveRecord::Base.connection
          rescue
            $stderr.puts $!, *($!.backtrace)
            $stderr.puts "Couldn't create database for #{config.inspect}"
          end
        end
        return # Skip the else clause of begin/rescue    
      else
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection
      end
    rescue
      case config['adapter']
      when 'mysql'
        @charset   = ENV['CHARSET']   || 'utf8'
        @collation = ENV['COLLATION'] || 'utf8_general_ci'
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => nil))
          ActiveRecord::Base.connection.create_database(config['database'], :charset => (config['charset'] || @charset), :collation => (config['collation'] || @collation))
          ActiveRecord::Base.establish_connection(config)
        rescue
          $stderr.puts "Couldn't create database for #{config.inspect}, charset: #{config['charset'] || @charset}, collation: #{config['collation'] || @collation} (if you set the charset manually, make sure you have a matching collation)"
        end
      when 'postgresql'
        @encoding = config[:encoding] || ENV['CHARSET'] || 'utf8'
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
          ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => @encoding))
          ActiveRecord::Base.establish_connection(config)
        rescue
          $stderr.puts $!, *($!.backtrace)
          $stderr.puts "Couldn't create database for #{config.inspect}"
        end
      end
    else
      $stderr.puts "#{config['database']} already exists"
    end
  end

  desc 'Drops the database for the current RACK_ENV'
  task :drop => :load_config do
    begin
      drop_database(ActiveRecord::Base.configurations)
    rescue Exception => e
      puts "Couldn't drop #{ActiveRecord::Base.configurations['database']} : #{e.inspect}"
    end
  end
  
  def drop_database(config)
    case config['adapter']
    when 'mysql'
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection.drop_database config['database']
    when /^sqlite/
      FileUtils.rm(File.join(RAILS_ROOT, config['database']))
    when 'postgresql'
      ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.drop_database config['database']
    end
  end
end