class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, default: 0
      t.date :due_date, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps

      t.index :status
      t.index :due_date
      t.index [ :user_id, :status ]
    end
  end
end
