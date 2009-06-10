set :rails_env, "qa"

#role :proxy,  "10.130.86.50", "10.130.86.51", :no_release => true
role :app,    "10.130.86.86"
role :web,    "10.130.86.86", :primary => true
#role :web,    "10.130.86.76"
#role :db,     "10.130.86.73", :primary => true, :no_release => true

