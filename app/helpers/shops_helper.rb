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
    link_to("#{shop.website_url} #{fa_icon("external-link")}".html_safe, shop.website_url, :target => :_blank)
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

  def render_shop_static_map(shop)
    base_url = "http://maps.googleapis.com/maps/api/staticmap?"

    parameters = "zoom=14&center=#{shop.lat},#{shop.lng}&sensor=false&size=320x320&"
    marker = "markers=color:red%7Clabel:S%7C#{shop.lat},#{shop.lng}"

    image_tag("#{base_url}#{parameters}#{marker}")

  end



end
