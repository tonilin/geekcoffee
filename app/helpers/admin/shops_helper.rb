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




end
