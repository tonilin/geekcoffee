module MapsHelper

  def render_landing_maps_btn
    link_to("開始尋找", maps_path, :class => "btn btn-primary btn-danger btn-lg")
  end


end
