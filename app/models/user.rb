class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  # Deleted duplicate attr_accessible line for Treasure_Hunter
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :provider, :uid, :name, :phone_number

  validates :username, uniqueness: true, presence: true
  validates :phone_number, presence: true, numericality: { only_integer: true }, length: { is: 10 }
end
