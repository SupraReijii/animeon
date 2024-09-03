# frozen_string_literal: true

FactoryBot.define do
  factory :episode do
    anime { create :anime }
    sequence(:name) { |n| "episode_#{n}" }
    episode_number { '1' }
  end
end
