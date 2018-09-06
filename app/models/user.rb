class User < ApplicationRecord
  has_many :bookings

  validates_presence_of :email, :first_name, :last_name
end
