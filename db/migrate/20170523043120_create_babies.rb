class CreateBabies < ActiveRecord::Migration
  def change
    create_table :babies do |t|
      t.string :name
      t.date :birthdate
      t.string :password_digest
      t.timestamps null: false
    end
  end
end
