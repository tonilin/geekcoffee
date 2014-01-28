SitemapGenerator::Sitemap.default_host = Setting.domain
SitemapGenerator::Sitemap.create_index = :auto


SitemapGenerator::Sitemap.create do

  add root_path, :priority => 1
  add maps_path, :priority => 0.7
  add new_shop_path, :priority => 0.7
  
  Shop.find_each do |shop|
    add shop_path(shop), :priority => 0.9
  end


end
