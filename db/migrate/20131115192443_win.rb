class Win < ActiveRecord::Migration
  def change
    add_column :hunt_users, :game_status, :boolean, default: true
  end
end
