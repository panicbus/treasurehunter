class Clues < ActiveRecord::Base
  attr_accessible :content, :location_id

  belongs_to :location

  validates :content, presence: true
end
