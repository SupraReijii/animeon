# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "email#{n}@factory.com" }
    role { :user }
    password { '123236' }
    sign_in_count { 7 }
    trait :admin do
      username { 'user_admin' }
      role { :admin }
    end
    trait :creator do
      username { 'user_creator' }
      role { :creator }
    end
  end
end
