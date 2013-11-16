class HuntLocation < ActiveRecord::Base
  attr_accessible :hunt_id, :location_id, :loc_order

  belongs_to :hunt
  belongs_to :location

  validates :location_id, presence: true
  validates :loc_order, presence: true
  validates :hunt_id, presence: true
end
