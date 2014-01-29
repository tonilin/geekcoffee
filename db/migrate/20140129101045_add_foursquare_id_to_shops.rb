class AddFoursquareIdToShops < ActiveRecord::Migration
  def change
    add_column :shops, :foursquare_id, :integer
  end
end
