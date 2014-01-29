class CreateFoursquares < ActiveRecord::Migration
  def change
    create_table :foursquares do |t|
      t.string  :foursquare_id
      t.text    :foursquare_data
      t.integer :shop_id
      t.timestamps
    end
  end
end
