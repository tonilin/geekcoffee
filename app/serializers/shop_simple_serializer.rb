class ShopSimpleSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :lat, :lng, :is_wifi_free, :power_outlets, :slug
end
