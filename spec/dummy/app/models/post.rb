class Post < ApplicationRecord
  has_and_belongs_to_many :tags # rubocop:disable Rails/HasAndBelongsToMany

  validates :title, presence: true
end
