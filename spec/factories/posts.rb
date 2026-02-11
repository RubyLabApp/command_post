FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    published { false }
  end
end
