class ShopDetailSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :lat, :lng, :description, :is_wifi_free, :power_outlets, :website_url, :avg_rating, :address, :cover_thumb_url


  def cover_thumb_url
    object.cover.thumb.url
  end

end
