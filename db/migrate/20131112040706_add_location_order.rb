class AddLocationOrder < ActiveRecord::Migration
  def change
    add_column :locations, :loc_order, :integer
  end

end
