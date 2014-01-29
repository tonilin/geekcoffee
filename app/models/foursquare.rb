# == Schema Information
#
# Table name: foursquares
#
#  id              :integer          not null, primary key
#  foursquare_id   :string(255)
#  foursquare_data :text
#  shop_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Foursquare < ActiveRecord::Base
  belongs_to :shop

  scope :recent, -> { order("id DESC") }

  def self.client
    Foursquare2::Client.new(
      :client_id => Setting.foursquare_id,
      :client_secret => Setting.foursquare_secret
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

  def rating
    json_data["rating"]
  end

  def json_data
    @json_data ||= JSON.parse(foursquare_data)
  end



end
