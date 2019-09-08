# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'ui(/:action)', controller: 'ui'

  resources :categories, only: :show
  resources :sessions, only: :create
  resources :users, only: :create
  resources :videos, only: :show do
    resources :reviews, only: :create
    get 'search', on: :collection
  end
end
