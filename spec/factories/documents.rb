FactoryBot.define do
  factory :document do
    sequence(:title) { |n| "Document #{n}" }
    published { false }
  end
end
