class ShopDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :lat, :lng, :address, :description, :is_wifi_free, :power_outlets, :hours, :website_url
end
