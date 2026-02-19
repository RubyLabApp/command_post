class Project < ApplicationRecord
  belongs_to :user, optional: true
end
