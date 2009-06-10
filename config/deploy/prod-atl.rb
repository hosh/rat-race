set :rails_env, "production"

role :proxy, "172.22.16.20", "172.22.16.22", :no_release => true

role :web, "172.22.16.20", :primary => true
role :web,                 "172.22.16.22"

role :app, "172.22.16.20", "172.22.16.22"
           
role :db,  "172.22.16.20", :primary => true, :no_release => true