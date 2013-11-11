class CreateHunts < ActiveRecord::Migration
  def change
    create_table :hunts do |t|
      t.string :title
      t.text :description
      t.string :prize
      t.string :date

      t.timestamps
    end
  end
end
