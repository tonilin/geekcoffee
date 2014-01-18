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

class Authorization < ActiveRecord::Base
  belongs_to :user, :inverse_of => :authorizations

  def refresh_token(token)
    self.update_attribute(:token, token)
  end

end
