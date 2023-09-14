Rails.application.routes.draw do
  root 'users#home'
  resources :users, only: [:create, :index]
  post 'users/home', to: 'users#home'
  get 'users/home', to: 'users#home'
end
