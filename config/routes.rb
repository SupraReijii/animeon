# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'dashboard#index'
  resources :user, only: %i[show], controller: 'users/users' do
    resource :list, only: %i[index] do
      get :anime
    end
  end
  resources :animes, only: %i[index show new create edit update] do
    collection do
      get :new_from_shikimori
      post :create_from_shikimori
    end
    resources :episodes, only: %i[show new create edit update] do
      resources :videos, only: %i[new create edit update]
    end
  end

end
