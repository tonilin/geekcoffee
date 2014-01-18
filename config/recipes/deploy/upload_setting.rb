namespace :deploy do
  
  desc "upload application.yml to server"
  task :upload_setting do
    run "mkdir -p #{deploy_to}/shared/config"
    transfer :up, "config/application.yml", "#{shared_path}/config/application.yml", :via => :scp
  end

end