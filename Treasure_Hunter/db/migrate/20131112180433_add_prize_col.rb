class AddPrizeCol < ActiveRecord::Migration
  def change
    add_column :hunts, :prize, :string
    add_column :hunts, :date, :datetime
    add_column :hunts, :start_location, :string
  end

  def down
  end
end
