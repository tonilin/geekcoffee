class Entities::Shops < Grape::Entity
  expose :id, :name, :lat, :lng, :is_wifi_free, :power_outlets, :distance
end