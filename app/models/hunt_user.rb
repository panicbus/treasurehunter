class HuntUser < ActiveRecord::Base
  attr_accessible :hunt_id, :progress, :role, :user_id, :game_status

  belongs_to :hunt
  belongs_to :user

  validate :hunt_id, presence: true
  validate :user_id, presence: true
  validate :role, presence: true
  validate :progress, presence: true
end
