class Clues < ActiveRecord::Base
  attr_accessible :answer, :question, :location_id

  belongs_to :location

  validates :question, presence: true
  validates :answer, presence: true
end
