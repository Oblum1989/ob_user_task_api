class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :full_name, null: false
      t.integer :role, default: 0

      t.timestamps

      t.index :email, unique: true
      t.index :role
    end
  end
end
