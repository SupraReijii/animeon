# frozen_string_literal: true

FactoryBot.define do
  factory :user_rate do
    user { create :user }
    target { create :anime }
    score { 0 }
    status { 6 }
    episodes { 0 }
    target_type { 'Anime' }
  end
end
