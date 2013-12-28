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

  validate :website_url_validator
  validates_presence_of :name, :address, :lat, :lng
  geocoded_by :latitude  => :lat, :longitude => :lng

  scope :recent, -> { order("id DESC") }

  has_reputation :avg_rating,
    :source => :user,
    :aggregated_by => :average

  def website_url_validator

    if website_url.present?
      if !(website_url =~ URI::regexp(%w(http https)))
        self.errors[:website_url] << "請輸入正確的網址"
      end
    end
  end



end
