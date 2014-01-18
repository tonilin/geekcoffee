# -*- encoding : utf-8 -*-

raw_config = File.read("config/config.yml")
APP_CONFIG = YAML.load(raw_config)

require "./config/boot"
require "bundler/capistrano"
require "rvm/capistrano"

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

set :scm_verbose, true


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


require 'airbrake/capistrano'