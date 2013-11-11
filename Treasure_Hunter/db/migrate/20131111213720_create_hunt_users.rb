class CreateHuntUsers < ActiveRecord::Migration
  def change
    create_table :hunt_users do |t|
      t.string :role
      t.integer :hunt_id
      t.integer :user_id
      t.string :progress

      t.timestamps
    end
  end
end
