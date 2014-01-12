class ShopDetailSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :lat, :lng, :address, :description, :is_wifi_free, :power_outlets, :hours, :website_url, :avg_rating, :user_rating


  def user_rating
    current_user.evaluated_value(object) if current_user
  end
end
