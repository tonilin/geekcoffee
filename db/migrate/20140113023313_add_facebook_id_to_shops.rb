class AddFacebookIdToShops < ActiveRecord::Migration
  def change
    add_column :shops, :facebook_id, :string
  end
end
