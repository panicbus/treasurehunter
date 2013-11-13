class HuntLocation < ActiveRecord::Base
  attr_accessible :hunt_id, :location_id, :loc_order

  belongs_to :hunt
  belongs_to :location
end
