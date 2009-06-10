# set :branch, Capistrano::CLI.ui.ask('Tag to deploy:')
# set :rails_env, "staging"
# 
# role :app, "192.168.243.12", "192.168.244.12", "192.168.245.12", "192.168.243.13", "192.168.244.13", "192.168.245.13"
# role :web, "192.168.243.12", "192.168.244.12", "192.168.245.12", "192.168.243.13", "192.168.244.13", "192.168.245.13"
# role :db, "192.168.243.12", :primary => true
# role :db, "192.168.241.12", :no_release => true
# 
# after "deploy:update", "run_cfagent"
# 
# desc "Run cfagent"
#         task :run_cfagent, :roles => :web do
#         run "/usr/bin/sudo /usr/sbin/cfagent --no-splay"
# end
# 
# 
# 
