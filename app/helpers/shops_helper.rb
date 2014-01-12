module ShopsHelper

  def render_shop_name(shop, link: true)
    if link
      link_to(shop.name, shop_path(shop))
    else
      shop.name
    end
  end

  def render_shop_address(shop)
    shop.address
  end

  def render_shop_website(shop)
    link_to(shop.website_url, shop.website_url)
  end

  def render_shop_hours(shop)
    shop.hours
  end

  def render_shop_if_wifi_free(shop)
    shop.is_wifi_free ? fa_icon("check") : fa_icon("times")
  end

  def render_shop_has_power_outlets(shop)
    shop.power_outlets ? fa_icon("check") : fa_icon("times")
  end

  def render_shop_description(shop)
    shop.description
  end


end
