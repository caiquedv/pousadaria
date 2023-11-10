Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :guesthouses, only: [:new, :create, :show, :edit, :update] do
    resources :rooms, only: [:new, :create, :show]
  end

  resources :rooms, only: [:edit, :update]
end
