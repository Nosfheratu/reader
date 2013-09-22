RedFeed::Application.routes.draw do
  
  match "/users/sign_in" => 'static_pages#index'
  
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  
  devise_scope :user do
    get "sign_out", :to => "devise/sessions#destroy", as: :sign_out
    get "sign_in", :to => "static_pages#index", as: :sign_in
    get '/auth/google_oauth2/callback', to: 'omniauth_callbacks#all'
    get '/auth/facebook/callback', to: 'omniauth_callbacks#facebook'
  end
  
  match 'users/tags/edit'  => 'tags#edit'
  match 'tag/move_to_folder' => 'tags#move_to_folder'
  
  resources :users do
    get "admin", "job", on: :member
    resources :tags
    resources :tag_entries
    resources :my_entries, :only => [:update, :show] do
      put 'update_star', on: :collection
      put 'mark_to_read', on: :collection
    end

    resources :my_feeds do
      get "request_fetch", on: :member
    end
  end
  
  match 'developer' => 'static_pages#developer', as: "developer"
  match 'about' => 'static_pages#about', as: "about"
  match 'faqs' => 'static_pages#faqs', as: "faqs"
  
  #ROOT
  root :to => 'static_pages#index'
  
end
