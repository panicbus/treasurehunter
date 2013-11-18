class HuntUser < ActiveRecord::Base
  attr_accessible :hunt_id, :progress, :role, :user_id, :game_status

  belongs_to :hunt
  belongs_to :user

  validates :hunt_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true
end
