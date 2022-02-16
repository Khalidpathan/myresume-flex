
Rails.application.routes.draw do
  get 'users/new'
  root   'home#index'
  get    'signup'  => 'users#new'
  get    'edit'    => 'home#edit'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get    'preview' => "profiles#preview"
  resources :users 
  resources :profiles
  resources :educations
  resources :experiences
  resources :projects 
end
