class AddRatingToFoursquares < ActiveRecord::Migration
  def change
    add_column :foursquares, :rating, :float
  end
end
