class CreateHunts < ActiveRecord::Migration
  def change
    create_table :hunts do |t|
      t.string :title
      t.text :description
      t.string :prize
      t.string :date
      t.string :start_location
      t.string :end

      t.timestamps
    end
  end
end
