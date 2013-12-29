class AddFormattedAddressToShops < ActiveRecord::Migration
  def change
    add_column :shops, :formatted_address, :string
    add_column :shops, :is_starbucks, :integer
  end
end
