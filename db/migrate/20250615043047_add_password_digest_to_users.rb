class AddPasswordDigestToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :password_digest, :string
    User.reset_column_information
    User.find_each do |user|
      user.password = 'temporary_password'
      user.save(validate: false)
    end
    change_column_null :users, :password_digest, false
  end

  def down
    remove_column :users, :password_digest
  end
end
