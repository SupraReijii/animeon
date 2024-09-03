# frozen_string_literal: true

FactoryBot.define do
  factory :video_url do
    sequence(:url) { |n| "https://cdn.animeon.ru/#{n}" }
    video { create :video }
  end
end
