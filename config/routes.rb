# frozen_string_literal: true

Rails.application.routes.draw do
  root 'dashboard#index'

  resources :animes, only: %i[index show new create edit update] do
    resources :episodes, only: %i[show new create edit update] do
      resources :video, only: %i[new create edit update] do
        get :video_url_new
        post :video_url_create
      end
    end
  end

end
