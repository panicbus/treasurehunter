class CreateHuntLocations < ActiveRecord::Migration
  def change
    create_table :hunt_locations do |t|
      t.integer :hunt_id
      t.integer :location_id

      t.timestamps
    end
  end
end
