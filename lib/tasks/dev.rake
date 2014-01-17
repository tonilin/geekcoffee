# -*- encoding : utf-8 -*-
namespace :dev do

  desc "Rebuild system"
  task :build => ["tmp:clear", "log:clear", "db:drop", "db:create", "db:migrate", "db:seed" ]
  
  desc "demo"
  task :demo => :environment do
  end

  desc "Import starbucks data"
  task :import_starbucks_data => :environment do
    starbucks = File.open(File.join(Rails.root, "starbucks.txt"), "r")

    datas = JSON.parse(starbucks.read)

    datas.each do |data|
      shop = Shop.new
      shop.name = data["name"]
      shop.address = data["origin_address"]
      shop.formatted_address = data["formatted_address"]
      shop.is_starbucks = true
      shop.website_url = "http://www.starbucks.com.tw/"
      shop.is_wifi_free = false
      shop.power_outlets = true
      shop.user_id = 1
      shop.lat = data["lat"]
      shop.lng = data["lng"]
      shop.hours = data["hours"]
      shop.save
    end

  end

  desc "fix_starbucks_data"
  task :fix_starbucks_data => :environment do
    starbucks = Shop.where("is_starbucks = ?", 1)

    starbucks.each do |starbuck|
      starbuck.name = "統一星巴克 #{starbuck.name}"
      starbuck.save
    end
  end

  desc "Save facebook id"
  task :save_facebook_id => :environment do
    Shop.find_each do |shop|
      if shop.parse_facebook_id.present?
        shop.facebook_id = shop.parse_facebook_id
        shop.save
        puts shop.id
      end
    end

  end



  desc "Generate_shops_slug"
  task :generate_shops_slug => :environment do
    User.find_each(&:save)
  end




end
