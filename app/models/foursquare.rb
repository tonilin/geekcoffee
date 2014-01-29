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
  belongs_to :user

  scope :recent, -> { order("id DESC") }

  def self.client
    Foursquare2::Client.new(
      :client_id => Setting.foursquare_id,
      :client_secret => Setting.foursquare_secret
    )
  end

end
