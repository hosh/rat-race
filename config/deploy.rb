require 'mongrel_cluster/recipes'
require 'capistrano/ext/multistage'

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

set :application,   "leads.primedia.com"
set :copy_cache,    "#{ENV['HOME']}/deploy/#{application}"
set :copy_exclude,  ['.git']
set :deploy_to,     "/var/www/#{application}"
set :deploy_via,    :copy
set :keep_releases, 5
#set :mongrel_conf,  "#{deploy_to}/current/config/mongrel_cluster.yml"  
set :repository,    "git@github.com:primedia/service_leads.git"
set :scm,           "git"
set :stages,        %w(qa staging production acceptance)
set :user,          "deploy"
set :use_sudo,      false

def tag_to_deploy  
  require_annotated = /refs\/tags\/(v.+\^\{\})$/ 
  all_version_tags      = `git ls-remote --tags #{repository}`.scan(require_annotated).flatten
  sorted_version_tags   = all_version_tags.sort_by{|v| v.split('.').map{|nbr| nbr[/\d+/].to_i}}
  stripped_version_tags = sorted_version_tags.map{|tag| tag.strip} 
  puts "stripped_version_tags: #{stripped_version_tags.class}"
  
  last_x_tags = []
  if stripped_version_tags.size > 10                               
    last_x_tags         = stripped_version_tags[-10..-1]
    puts "last_ten_tags: #{last_x_tags}"   
  else                                            
     max = stripped_version_tags.size
     last_x_tags         = stripped_version_tags[-max..-1]
    puts "last_ten_tags: #{last_x_tags}"
  end
  
  tag = Capistrano::CLI.ui.choose { |menu|
    menu.choices *last_x_tags
    
    menu.header    = "Available tags"
    menu.prompt    = "Tag to deploy?"
    menu.select_by = :index_or_name
  }
end

task(:set_branch) { set :branch, stage == :acceptance ? "master" : tag_to_deploy }
after 'multistage:ensure', :set_branch

#before  "deploy:finalize_update", "symlink_images"
after   "deploy:update",          "run_cfagent"

desc "Run cfagent"
	task :run_cfagent, :roles => :web do
	run "/usr/bin/sudo /usr/sbin/cfagent --no-splay -K"
end

namespace :deploy do
  desc "Perform a deploy:setup and deploy:cold"
  task :init do 
    transaction do
      deploy.setup
      deploy.cold
    end
  end
  
  desc "Perform a code update, sanity_check, symlink and migration"
  task :full do
    transaction do
      deploy.update

      add_version_file
      # update gems must be done elsewhere
      #gotta do manually/or with cfengine, 
      thin.stop
      sleep(3)
      #remote_db_migrate
      thin.start
      deploy.cleanup
    end
  end
  
  desc "Deploy locally"
  task :local do
    transaction do
      run "cp -R #{current_path} #{release_path}"
    end
  end

  desc "run remote rake db:migrate RAILS_ENV=<env>"
   task :remote_db_migrate do
     rake_cmd = `which rake`.chomp
     cmd = "cd #{deploy_to}/current; RACK_ENV=#{rails_env} #{rake_cmd} db:migrate "
     run cmd
   end
   
   desc "Put the version that was deployed into RAILS_ROOT/VERSION"
   task :add_version_file, :roles => :web do
     run "cd #{current_path} && echo #{branch} > VERSION"
   end
   

end

# Uncomment for Thin 

#example restart: 
# thin start -c /var/www/leads.primedia.com/current -C /var/www/leads.primedia.com/current/config/qa_thin.yml -e qa
namespace :thin do  
  %w(start stop restart).each do |action| 
    desc "#{action} the app's Thin Cluster"  
    task action.to_sym, :roles => :app do  
      # if you change to mongrel you must implement RACK_ENV=#{rails_env}. thin uses -e , mongrel uses the former.
      cmd =  "thin #{action} -c #{deploy_to}/current -C /etc/thin/leads.yml -e #{rails_env}"
      run cmd
    end
  end
end   





