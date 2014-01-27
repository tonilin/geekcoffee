class ShopDetailSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :lat, :lng, :description, :is_wifi_free, :power_outlets, :website_url, :avg_rating, :cover_thumb_url


  def cover_thumb_url
    object.cover.thumb.url
  end


  def user_rating
    current_user.evaluated_value(object) if current_user
  end
end
