# frozen_string_literal: true

FactoryBot.define do
  factory :anime do
    sequence(:name) { |n| "anime_#{n}" }
    description { '' }
    status { 'released' }
    user_rating { 0 }
    episodes { 0 }
    franchise { nil }
    episodes_aired { 0 }
  end
end
