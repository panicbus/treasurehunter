class CreateClues < ActiveRecord::Migration
  def change
    create_table :clues do |t|
      t.text :content
      t.integer :location_id

      t.timestamps
    end
  end
end
