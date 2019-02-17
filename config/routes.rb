Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  resources :users
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
