class Tag < ApplicationRecord
  has_and_belongs_to_many :posts # rubocop:disable Rails/HasAndBelongsToMany

  validates :name, presence: true, uniqueness: true
end
