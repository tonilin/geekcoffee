# == Schema Information
#
# Table name: shops
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  description       :text
#  address           :string(255)
#  hours             :string(255)
#  lat               :float
#  lng               :float
#  is_wifi_free      :boolean          default(FALSE)
#  power_outlets     :boolean          default(FALSE)
#  plug_price        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  user_id           :integer
#  website_url       :string(255)
#  formatted_address :string(255)
#  is_starbucks      :integer
#

require 'spec_helper'

describe Shop do
  pending "add some examples to (or delete) #{__FILE__}"
end
