class License < ApplicationRecord
  belongs_to :user

  enum :status, { active: 0, expired: 1, revoked: 2 }

  validates :license_key, presence: true, uniqueness: true
end
