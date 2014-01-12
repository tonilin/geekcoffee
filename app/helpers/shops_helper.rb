module ShopsHelper

  def render_shop_name(shop, link: true)
    Rails.logger.info(link.to_json)

    if link
      link_to(shop.name, shop_path(shop))
    else
      shop.name
    end
  end


end
