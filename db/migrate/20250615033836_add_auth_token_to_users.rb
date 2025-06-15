class AddAuthTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :auth_token, :string, null: false, default: ""
    add_column :users, :password, :string, null: false, default: ""
  end
end
