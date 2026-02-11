FactoryBot.define do
  factory :profile do
    user
    bio { "A short bio about this user." }
    website { "https://example.com" }
    avatar_url { "https://example.com/avatar.png" }
    color_hex { "#3b82f6" }
    hourly_rate { 75.50 }
  end
end
