class Entities::Shop < Grape::Entity
  expose :id, :name, :lat, :lng, :address, :description, :is_wifi_free, :power_outlets, :hours, :website_url, :avg_rating

end