# == Schema Information
#
# Table name: foursquares
#
#  id              :integer          not null, primary key
#  foursqaure_id   :string(255)
#  foursqaure_data :text
#  shop_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Foursquare < ActiveRecord::Base
  belongs_to :user


  def self.client
    Foursquare2::Client.new(
      :client_id => Setting.foursquare_id,
      :client_secret => Setting.foursquare_secret
    )
  end

end
