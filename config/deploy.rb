# -*- encoding : utf-8 -*-

raw_config = File.read("config/config.yml")
APP_CONFIG = YAML.load(raw_config)

require "./config/boot"
require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano-unicorn'

default_environment["PATH"] = "/opt/ruby/bin:/usr/local/bin:/usr/bin:/bin"

set :application, "geekcoffee"
set :repository,  "git@github.com:tonilin/geekcoffee.git"
set :deploy_to, "/home/apps/#{application}"

set :branch, "master"
set :scm, :git

set :user, "apps"
set :group, "apps"

set :deploy_to, "/home/apps/#{application}"
set :runner, "apps"
set :deploy_via, :remote_cache

set :use_sudo, false
set :rvm_ruby_string, '2.1.0'

set :hipchat_token, APP_CONFIG["production"]["hipchat_token"]
set :hipchat_room_name, APP_CONFIG["production"]["hipchat_room_name"]
set :hipchat_announce, false # notify users?

role :web, "geekcoffee.roachking.net"                          # Your HTTP server, Apache/etc
role :app, "geekcoffee.roachking.net"                         # This may be the same as your `Web` server
role :db,  "geekcoffee.roachking.net"   , :primary => true # This is where Rails migrations will run

set :deploy_env, "production"
set :rails_env, "production"
set :scm_verbose, true

namespace :sitemap do

  desc "refresh sitemap"
  task :refresh do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
  end

  desc "refresh sitemap without ping"
  task :refresh_without_ping do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake -s sitemap:refresh"
  end

  desc "copy_old_sitemap"
  task :copy_old_sitemap do
    run "if [ -e #{previous_release}/public/sitemap.xml.gz ]; then cp #{previous_release}/public/sitemap*.xml.gz #{current_release}/public/; fi"
  end
end


namespace :my_tasks do
  task :symlink, :roles => [:web] do
    run "mkdir -p #{deploy_to}/shared/log"
    run "mkdir -p #{deploy_to}/shared/pids"
    
    symlink_hash = {
      "#{shared_path}/config/database.yml"   => "#{release_path}/config/database.yml",
      "#{shared_path}/config/application.yml"   => "#{release_path}/config/application.yml",
      "#{shared_path}/uploads"              => "#{release_path}/public/uploads",
    }

    symlink_hash.each do |source, target|
      run "ln -sf #{source} #{target}"
    end
  end

end


after "deploy:finalize_update", "my_tasks:symlink"
after "deploy:finalize_update", "sitemap:copy_old_sitemap"

after 'deploy:restart', 'unicorn:restart'  # app preloaded

require 'airbrake/capistrano'