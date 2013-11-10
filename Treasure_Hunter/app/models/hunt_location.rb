class HuntLocation < ActiveRecord::Base
  attr_accessible :hunt_id, :location_id

  belongs_to :hunt
  belongs_to :location
end
