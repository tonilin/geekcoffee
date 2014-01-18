require 'capistrano-unicorn'

set :deploy_env, "staging"
set :rails_env,  "staging"

role :web, "geekcoffee-staging.roachking.net"                   # Your HTTP server, Apache/etc
role :app, "geekcoffee-staging.roachking.net"                   # This may be the same as your `Web` server
role :db,  "geekcoffee-staging.roachking.net", :primary => true # This is where Rails migrations will run

after "deploy:update_code", "deploy:copy_old_sitemap"
after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded
