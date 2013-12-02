class ShopSimpleSerializer < ActiveModel::Serializer
  attributes :id, :name, :lat, :lng
end
