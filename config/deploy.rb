# -*- encoding : utf-8 -*-

raw_config = File.read("config/config.yml")
APP_CONFIG = YAML.load(raw_config)

require "./config/boot"
require "bundler/capistrano"
require "rvm/capistrano"

default_environment["PATH"] = "/opt/ruby/bin:/usr/local/bin:/usr/bin:/bin"

set :application, "geekcoffee"
set :repository,  "git@github.com:example/#{application}.git"
set :deploy_to, "/home/apps/#{application}"

set :branch, "master"
set :scm, :git

set :user, "apps"
set :group, "apps"

set :deploy_to, "/home/apps/#{application}"
set :runner, "apps"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :use_sudo, false
set :rvm_ruby_string, '2.0.0'

set :hipchat_token, APP_CONFIG["production"]["hipchat_token"]
set :hipchat_room_name, APP_CONFIG["production"]["hipchat_room_name"]
set :hipchat_announce, false # notify users?

role :web, "geekcoffee.com"                          # Your HTTP server, Apache/etc
role :app, "geekcoffee.com"                         # This may be the same as your `Web` server
role :db,  "geekcoffee.com"   , :primary => true # This is where Rails migrations will run

set :deploy_env, "production"
set :rails_env, "production"
set :scm_verbose, true
set :use_sudo, false


namespace :deploy do

  desc "Restart passenger process"
  task :restart, :roles => [:web], :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end


namespace :my_tasks do
  task :symlink, :roles => [:web] do
    run "mkdir -p #{deploy_to}/shared/log"
    run "mkdir -p #{deploy_to}/shared/pids"
    
    symlink_hash = {
      "#{shared_path}/config/database.yml"   => "#{release_path}/config/database.yml",
      "#{shared_path}/config/s3.yml"   => "#{release_path}/config/s3.yml",
      "#{shared_path}/uploads"              => "#{release_path}/public/uploads",
    }

    symlink_hash.each do |source, target|
      run "ln -sf #{source} #{target}"
    end
  end

end



namespace :remote_rake do
  desc "Run a task on remote servers, ex: cap staging rake:invoke task=cache:clear"
  task :invoke do
    run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} bundle exec rake #{ENV['task']}"
  end
end

after "deploy:finalize_update", "my_tasks:symlink"

after 'deploy:restart', 'unicorn:reload' # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'  # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)
