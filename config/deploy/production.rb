require 'capistrano-unicorn'

set :deploy_env, "production"
set :rails_env,  "production"

role :web, "geekcoffee.roachking.net"                   # Your HTTP server, Apache/etc
role :app, "geekcoffee.roachking.net"                   # This may be the same as your `Web` server
role :db,  "geekcoffee.roachking.net", :primary => true # This is where Rails migrations will run

after "deploy:update_code", "deploy:sitemap:copy_old_sitemap"
after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded
