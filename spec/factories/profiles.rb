FactoryBot.define do
  factory :profile do
    user
    bio { "A short bio about this user." }
    website { "https://example.com" }
    avatar_url { "https://example.com/avatar.png" }
  end
end
