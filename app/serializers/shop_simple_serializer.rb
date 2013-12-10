class ShopSimpleSerializer < ActiveModel::Serializer
  attributes :id, :name, :lat, :lng, :is_wifi_free, :power_outlets
end
