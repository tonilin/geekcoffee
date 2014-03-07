class ChangeTokenToTextToAuthorizations < ActiveRecord::Migration
  def change
    change_column :authorizations, :token, :text
  end
end
