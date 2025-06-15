class AddAuthTokenIndexToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :auth_token, unique: true, name: 'index_users_on_auth_token'
  end
end
