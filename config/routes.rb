Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users
  root 'home#index'
  resources :conversations, only: [:create] do
    member do
      post :close
    end

    resources :messages, only: [:create] do 
      collection do
        post :upload_attachment
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
