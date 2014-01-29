class Foursquare < ActiveRecord::Base



  def self.client
    Foursquare2::Client.new(
      :client_id => Setting.foursquare_id,
      :client_secret => Setting.foursquare_secret
    )
  end

end
