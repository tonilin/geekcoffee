module MapsHelper

  def render_landing_maps_btn
    link_to("開始尋找", maps_path, :class => "btn btn-primary btn-success btn-large")
  end


end
