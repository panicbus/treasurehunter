class Hunt < ActiveRecord::Base
  attr_accessible :description, :title

  has_many :locations
  has_many :hunt_locations
  has_many :clues, through: :locations # Is this needed?

  validates :title, presence: true
  validates :description, presence: true
end
