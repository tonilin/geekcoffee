namespace :deploy do
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
end