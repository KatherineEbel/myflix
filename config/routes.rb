Rails.application.routes.draw do
  root to: 'videos#index'
  get '/home', to: 'videos#index'
  resources :videos, only: %i[show] do
    get 'search', on: :collection
  end
  resources :categories, only: %i[show]
  get 'ui(/:action)', controller: 'ui'

end
