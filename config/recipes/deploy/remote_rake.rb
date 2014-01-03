namespace :deploy do
  namespace :remote_rake do
    desc "Run a task on remote servers, ex: cap staging rake:invoke task=cache:clear"
    task :invoke do
      run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} bundle exec rake #{ENV['task']}"
    end
  end
end