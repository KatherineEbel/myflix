# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'ui', to: 'ui#index'

  namespace 'ui' do
    ui_views_path = Rails.root.join('app', 'views', 'ui')
    Dir.entries(ui_views_path)
       .reject { |entry| entry.start_with? '.' }
       .map { |view| view.partition('.').first }
       .each do |action|
      get action, action: action
    end
  end

  resources :categories, only: :show
  resources :queue_items, only: :destroy do
    patch 'update', on: :collection
  end
  resources :sessions, only: :create

  resources :users, only: [:create] do
    get 'profile', on: :member
  end

  resources :videos, only: :show do
    resources :queue_items, only: :create
    resources :reviews, only: :create
    get 'search', on: :collection
  end
end
