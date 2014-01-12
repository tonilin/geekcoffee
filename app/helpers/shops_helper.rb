module ShopsHelper

  def render_shop_name(shop, link: true)
    if link
      link_to(shop.name, shop_path(shop))
    else
      shop.name
    end
  end


end
