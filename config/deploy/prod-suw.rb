set :rails_env, "production"

role :proxy, "172.16.122.105", "172.16.122.106", :no_release => true

role :web, "172.16.122.105", :primary => true
role :web,                 "172.16.122.106"

role :app, "172.16.122.105", "172.16.122.106"
           
role :db,  "172.16.122.105", :primary => true, :no_release => true