# frozen_string_literal: true

FactoryBot.define do
  factory :widget do
    sequence(:name) { |n| "Widget #{n}" }
    status { "active" }
    completion { 50 }
  end
end
