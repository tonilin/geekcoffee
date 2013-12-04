class Authorization < ActiveRecord::Base
  belongs_to :user, :inverse_of => :authorizations
end
