# == Schema Information
#
# Table name: shops
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  address        :string(255)
#  format_address :string(255)
#  hours          :string(255)
#  lat            :decimal(10, 6)
#  lng            :decimal(10, 6)
#  is_wifi_free   :boolean
#  have_plugs     :boolean
#  plug_price     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Shop < ActiveRecord::Base
  validates_presence_of :name, :address, :lat, :lng


end
