# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  authentication_token   :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  extend OmniauthCallbacks

  has_many :authorizations, :dependent => :destroy
  has_many :shops, :dependent => :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  scope :recent, -> { order("id DESC") }

  before_save :ensure_authentication_token

  def bind_service(provider, uid)
    binding = User.find_binding(provider, uid)

    authorizations.create(:provider => provider , :uid => uid ) if !binding      
  end

  def self.find_binding(provider, uid)
    Authorization.find_by_provider_and_uid(provider, uid )
  end


  def admin?
    Setting.admin_emails.include?(email)
  end

  def evaluate_shop(shop, value)
    shop.add_or_update_evaluation(:avg_rating, value, self)
  end

  def delete_shop_evaluation(shop)
    shop.delete_evaluation(:avg_rating, self)
  end

  def evaluated_shop?(shop)
    shop.has_evaluation?(:avg_rating, self)
  end

  def evaluated_value(shop)
    evaluated_record = shop.evaluations(:avg_rating).where(:source => self).first
  
    if evaluated_record
      evaluated_record.value
    else
      nil
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def ensure_authentication_token!
    ensure_authentication_token
    self.save
  end

  def reset_authentication_token
    self.authentication_token = generate_authentication_token
  end

  def reset_authentication_token!
    reset_authentication_token
    self.save
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end


end
