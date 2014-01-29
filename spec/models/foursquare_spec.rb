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

require 'spec_helper'

describe Foursquare do
  pending "add some examples to (or delete) #{__FILE__}"
end
