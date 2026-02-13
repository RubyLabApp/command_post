class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true, optional: true
end
