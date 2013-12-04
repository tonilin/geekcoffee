class AddWebsiteUrlToShops < ActiveRecord::Migration
  def change
    add_column :shops, :website_url, :string
  end
end
