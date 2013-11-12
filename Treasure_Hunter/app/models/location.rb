class Location < ActiveRecord::Base
  attr_accessible :lat, :long, :loc_order

  has_many :clues
  has_many :hunts
  has_many :hunt_locations

  validates :lat, presence: true
  validates :long, presence: true
end
