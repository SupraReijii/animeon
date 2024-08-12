# frozen_string_literal: true

Rails.application.routes.draw do
  root 'dashboard#index'

  resources :animes, only: %i[index show new create edit update]
end
