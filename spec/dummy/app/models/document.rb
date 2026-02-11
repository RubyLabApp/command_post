class Document < ApplicationRecord
  has_one_attached :cover_image
  has_many_attached :attachments
  has_rich_text :content

  validates :title, presence: true
end
