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
#  is_starbucks      :integer          default(0)
#  phone             :string(255)
#  facebook_id       :string(255)
#  slug              :string(255)
#

class Shop < ActiveRecord::Base
  belongs_to :user

  validate :website_url_validator
  validates_presence_of :name, :address, :lat, :lng
  geocoded_by :address, :latitude  => :lat, :longitude => :lng

  scope :recent, -> { order("id DESC") }

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_reputation :avg_rating,
    :source => :user,
    :aggregated_by => :average

  before_create :save_facebook_id

  mount_uploader :cover, CoverUploader

  def website_url_validator

    if website_url.present?
      if !(website_url =~ URI::regexp(%w(http https)))
        self.errors[:website_url] << "請輸入正確的網址"
      end
    end
  end

  def avg_rating
    self.reputation_for(:avg_rating)
  end

  def facebook_page?
    # https://gist.github.com/marcgg/733592

    facebook_id.present?
  end

  def facebook_avatar
    "http://graph.facebook.com/#{facebook_id}/picture?width=320&height=320" if facebook_page?
  end

  def parse_facebook_id
    return if website_url.blank?

    matching = website_url.match(/(?:https?:\/\/)?(?:www\.)?facebook\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*?(\/)?([\w\-\.]*)/)

    return matching[2] if matching && matching[2].present?
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end


  private

  def save_facebook_id
    self.facebook_id = parse_facebook_id || nil
  end

end
