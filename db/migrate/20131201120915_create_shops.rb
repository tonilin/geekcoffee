class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string  :name
      t.text :description
      t.string  :address
      t.string  :hours
      t.decimal :lat, :precision => 10, :scale=> 6
      t.decimal :lng, :precision => 10, :scale=> 6
      t.boolean :is_wifi_free, :default => false
      t.boolean :power_outlets, :default => false
      t.integer :plug_price
      t.timestamps
    end
  end
end
