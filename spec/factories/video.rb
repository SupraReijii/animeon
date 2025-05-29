# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    episode { create :episode }
    fandub { create :fandub }
    status { :ready }
    quality { ['480p'] }
  end
end
