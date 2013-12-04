# == Schema Information
#
# Table name: shops
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text
#  address       :string(255)
#  hours         :string(255)
#  lat           :float
#  lng           :float
#  is_wifi_free  :boolean          default(FALSE)
#  power_outlets :boolean          default(FALSE)
#  plug_price    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  website_url   :string(255)
#

class Shop < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :address, :lat, :lng
  geocoded_by :latitude  => :lat, :longitude => :lng


end
