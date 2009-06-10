$:.unshift File.join(File.dirname(__FILE__), '..')
require 'rubygems'
require 'sinatra'
require 'vendor/sinatras-hat/lib/sinatras-hat'

class NewApp < Sinatra::Default
  configure do
    # require 'activerecord' 
    # ActiveRecord::Base.logger = Logger.new(STDOUT)
    # ActiveRecord::Base.establish_connection(YAML::load(IO.read(File.join(root, "../config/database.yml")))[environment.to_s])
    disable :run
  end
  
  before do
    # ActiveRecord::Base.connection.verify!
  end
  
  error do
   'Internal Server Error!'
  end
  
  not_found do
   'Not found.'
  end

  get '/' do 
    'New App'
  end

  get "/ops/heartbeat" do
    'New App OK'
  end
  
  get '/ops/version' do
    @app_name = "New App"
    @app_git_path = "https://github.com/primedia/new_app"
    @repository = "new_app"
    begin
      @version = File.read('./VERSION').chomp.gsub('^{}', '')
      @deploy_date = File.stat('./VERSION').mtime
    rescue Errno::ENOENT
    ensure
      @version ||= "Unknown (VERSION file is missing)"
      @deploy_date ||= "Unknown (VERSION file is missing)"
    end
    begin
      @git_version = File.read('./REVISION').chomp
    rescue Errno::ENOENT
    ensure
      @git_version ||= "Unknown (REVISION file is missing)"
    end
    @hostname = %x(/bin/hostname) 
    @hostname = @hostname.blank? ? "Unknown" : @hostname
  
    haml :'ops/version'
  end
  
  helpers do  
    def simple_link(name,url,style)
      "<a href =\"#{url}\" style=\"#{style}\">#{name}</a>"
    end
  end
end