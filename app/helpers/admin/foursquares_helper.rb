module Admin::FoursquaresHelper

  def render_foursquare_foursquare_id(foursquare)
    link_to(foursquare.id, foursquare.foursquare_url, :target => :blank)
   
  end



  def render_foursquare_shop_create_btn(foursquare)
    button_link_to(
      "Create Shop",
      create_shop_admin_foursquare_path(foursquare),
      :remote => true,
      :method => :post,
      :class => "btn btn-primary foursquare-shop-create-btn"
    )
  end

end
