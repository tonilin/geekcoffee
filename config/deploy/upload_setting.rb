namespace :deploy do
  
  desc "upload application.yml to server"
  namespace :upload_setting do
    transfer :up, "config/application.yml", "#{shared_path}/config/application.yml", :via => :scp
  end

end