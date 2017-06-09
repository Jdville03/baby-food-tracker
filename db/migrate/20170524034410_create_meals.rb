class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.date :entry_date
      t.time :entry_time
      t.string :food_type
      t.decimal :amount
      t.decimal :duration
      t.string :ingredients
      t.text :notes
      t.integer :baby_id
      t.timestamps null: false
    end
  end
end
