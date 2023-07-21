Rails.application.routes.draw do

  resources :animes, only: %i[index]

  root "dashboard#index"
end
