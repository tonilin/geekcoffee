# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  user_id    :integer
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Authorization do
  pending "add some examples to (or delete) #{__FILE__}"
end
