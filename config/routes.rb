Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  get '/guesthouses/advanced_search', to: 'guesthouses#advanced_search', as: 'advanced_search_guesthouses'
  
  get '/guesthouses/cities/:city_slug', to: 'guesthouses#city', as: 'city_guesthouses'
  get '/guesthouses/search', to: 'guesthouses#search', as: 'search_guesthouses'

  resources :guesthouses, only: [:new, :create, :show, :edit, :update] do
    resources :rooms, only: [:new, :create, :show]
  end

  resources :rooms, only: [:index, :edit, :update] do 
    resources :seasonal_rates, only: [:new, :create]
  end
end
