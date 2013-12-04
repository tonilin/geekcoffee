class AddUserIdToShops < ActiveRecord::Migration
  def change
    add_column :shops, :user_id, :integer 
  end
end
