SitemapGenerator::Sitemap.default_host = Setting.domain
SitemapGenerator::Sitemap.create_index = true


SitemapGenerator::Sitemap.create do

  add root_path
  add maps_path
  add new_shop_path
  
  Shop.find_each do |shop|
    add shop_path(shop)
  end


end
