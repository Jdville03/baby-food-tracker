class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.date :entry_date
      t.decimal :weight
      t.decimal :height
      t.integer :baby_id
      t.timestamps null: false
    end
  end
end
