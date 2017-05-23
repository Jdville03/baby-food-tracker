class CreateUserBabies < ActiveRecord::Migration
  def change
    create_table :user_babies do |t|
      t.integer :user_id
      t.integer :baby_id
      t.timestamps null: false
    end
  end
end
