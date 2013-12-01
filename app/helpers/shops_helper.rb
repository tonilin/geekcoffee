module ShopsHelper


  def render_langing_shop_new_btn
    link_to("建立咖啡廳", new_shop_path, :class => "btn btn-primary")
  end

end
