# frozen_string_literal: true

FactoryBot.define do
  factory :fandub do
    sequence(:name) { |n| "fandub_#{n}" }
    description { '' }
    members { [''] }
    date_of_foundation { nil }
  end
end
