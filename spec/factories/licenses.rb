FactoryBot.define do
  factory :license do
    user
    sequence(:license_key) { |n| "KEY-#{n.to_s.rjust(6, "0")}" }
    status { :active }
    license_type { "standard" }
    max_devices { 3 }
    expires_at { 1.year.from_now }
  end
end
