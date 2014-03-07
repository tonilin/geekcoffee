# == Schema Information
#
# Table name: foursquares
#
#  id              :integer          not null, primary key
#  foursquare_id   :string(255)
#  foursquare_data :text
#  created_at      :datetime
#  updated_at      :datetime
#

class Foursquare < ActiveRecord::Base
  has_one :shop

  scope :recent, -> { order("id DESC") }
  scope :order_by_rating, -> { order("rating DESC") }
  scope :not_imported, -> do 
    joins("LEFT JOIN shops ON shops.foursquare_id = foursquares.id").where(["shops.id IS NULL"])
  end
  scope :imported, -> do 
    joins("LEFT JOIN shops ON shops.foursquare_id = foursquares.id").where(["shops.id IS NOT NULL"])
  end

  def self.client
    Foursquare2::Client.new(
      :client_id => Setting.foursquare_id,
      :client_secret => Setting.foursquare_secret,
      :api_version => '20131016'
    )
  end

  def name
    json_data["name"]
  end

  def phone
    json_data["contact"]["formattedPhone"]
  end

  def address
    json_data["location"]["address"]
  end

  def lat
    json_data["location"]["lat"]
  end

  def lng
    json_data["location"]["lng"]
  end

  def foursquare_url
    json_data["canonicalUrl"]
  end

  def free_wifi?
    json_data["tags"].include?("free wifi")
  end


  def json_data
    @json_data ||= JSON.parse(foursquare_data)
  end



end
