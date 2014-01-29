class CreateFoursquares < ActiveRecord::Migration
  def change
    create_table :foursquares do |t|
      t.string  :foursqaure_id
      t.text    :foursqaure_data
      t.integer :shop_id
      t.timestamps
    end
  end
end
