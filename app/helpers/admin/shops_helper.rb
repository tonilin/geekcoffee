module Admin::ShopsHelper

  def render_admin_shop_name(shop)
    shop.name
  end

  def render_admin_shop_address(shop)
    shop.address
  end

  def render_admin_shop_hours(shop)
    shop.hours
  end

  def render_admin_shop_is_wifi_free(shop)
    shop.is_wifi_free
  end
  
  def render_admin_shop_power_outlets(shop)
    shop.power_outlets
  end

  def render_admin_shop_edit_btn(shop)
    link_to("Edit", edit_admin_shop_path(shop))
  end


end
