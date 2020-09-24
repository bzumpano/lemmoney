class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable


  #  Validations

  ## Presence

  validates :email,
    presence: true

  ## Uniqueness

  validates_uniqueness_of :email
end

