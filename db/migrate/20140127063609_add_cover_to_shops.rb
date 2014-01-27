class AddCoverToShops < ActiveRecord::Migration
  def change
    add_column :shops, :cover, :string
  end
end
