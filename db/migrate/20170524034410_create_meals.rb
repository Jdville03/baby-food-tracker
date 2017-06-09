class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.datetime :entry_datetime
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
