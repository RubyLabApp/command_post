class User < ApplicationRecord
  has_many :licenses
  has_one :profile

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
