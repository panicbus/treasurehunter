class CreateClues < ActiveRecord::Migration
  def change
    create_table :clues do |t|
      t.string :answer
      t.text :question
      t.integer :location_id

      t.timestamps
    end
  end
end
