module ShopsHelper


  def render_landing_maps_btn
    link_to("尋找咖啡廳", maps_path, :class => "btn btn-primary")
  end

end
