Rails3BootstrapDeviseCancan::Application.routes.draw do
  resources :authentications, :only =>[:create, :destroy]
  devise_for :users,  :controllers => {:registrations => 'registrations'}
  resources :users do
    resources :profile
  end
  match '/auth/:provider/callback' => 'authentications#create'
  root :to => 'home#index'
  authenticated :user do
    root :to => 'home#index'
  end
  get 'home/index'
  root :to => 'home#index'
  get 'login' => 'home#login'
  match '/account' => 'home#account'
  match '/social_media' => 'home#social_media'
  match '/manage_ngo' => 'home#manage_ngo'
  match '/ngo' => 'home#enroll_ngo'
  match '/ngo/:id' => 'home#enroll_ngo'
  match '/change_url' => 'home#change_url'
  match '/change_picture' => 'home#change_picture'
  match '/change_picture/:id' => 'home#change_picture'
  match 'ajax.:action' => 'ajax'
  match '/change_avatar/:provider' => 'avatars#change'
  match '/set_avatar/:provider_name' => 'avatars#set_avatar'
  match '/profile/:id' => 'profile#show'
  match '/friends_and_causes' => 'home#friends_and_causes'
  match 'search' => 'home#search'
  match '/:slug' => 'profile#show'
end

