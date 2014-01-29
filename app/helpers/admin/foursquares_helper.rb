module Admin::FoursquaresHelper

  def render_foursquare_shop_create_btn(foursquare)
    button_link_to(
      "Create Shop",
      create_shop_admin_foursquare_path(foursquare),
      :remote => true,
      :method => :post
    )
  end

end
