# -*- encoding : utf-8 -*-
SeoHelper.configure do |config|
  config.skip_blank               = false
  config.site_name = Setting.app_name
  config.default_page_description = "Geek Coffee, 尋找你附近的咖啡廳"
  config.default_page_keywords    = "咖啡館, 咖啡, 上網, 咖啡店, 喝咖啡, Geek Coffee,Geek, wifi, cafe, coffee, free"
  config.default_page_image = Setting.domain + Setting.default_logo_url
  config.site_name_formatter  = lambda { |title, site_name|   "#{title} « #{site_name}".html_safe }
  config.pagination_formatter = lambda { |title, page_number| "#{title} - Page No.#{page_number}" }

end
