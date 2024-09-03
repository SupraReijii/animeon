# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    episode { create :episode }
    fandub { create :fandub }
    quality { ['480p'] }
  end
end
