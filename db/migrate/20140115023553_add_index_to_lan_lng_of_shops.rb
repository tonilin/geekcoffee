class AddIndexToLanLngOfShops < ActiveRecord::Migration
  def change
    add_index :shops, [:lat, :lng]
  end
end
