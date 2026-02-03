class User < ApplicationRecord
  has_many :licenses

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
