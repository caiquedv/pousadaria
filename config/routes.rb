Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  get '/guesthouses/advanced_search', to: 'guesthouses#advanced_search', as: 'advanced_search_guesthouses'
  get '/guesthouses/cities/:city_slug', to: 'guesthouses#city', as: 'city_guesthouses'
  get '/guesthouses/search', to: 'guesthouses#search', as: 'search_guesthouses'

  resources :guesthouses, only: [:new, :create, :show, :edit, :update] do
    resources :rooms, only: [:new, :create, :show]
    resources :reviews, only: [:index]
  end

  resources :rooms, only: [:index, :edit, :update] do 
    resources :seasonal_rates, only: [:new, :create]
    
    resources :reservations, only: [:new, :create]
    get '/verify_reservation', to: 'reservations#verify_reservation', as: 'verify_reservation'
    get '/new_reservation', to: 'reservations#reservation_with_auth', as: 'reservation_with_auth'
  end

  resources :reservations, only: [:index, :show] do 
    resources :reviews, only: [:new, :create]

    member do
      patch :cancel
      patch :check_in
      get :check_out
      patch :finish
    end
  end

  resources :reviews, only: [:index]

  namespace :api do 
    namespace :v1 do
      resources :guesthouses, only: [:index, :show] do
        resources :rooms, only: [:index]
      end
      
      resources :rooms, only: [] do
        post 'availability', on: :member
      end
    end
  end



end
