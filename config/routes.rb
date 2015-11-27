Rails.application.routes.draw do

  # Static stuff
  root 'static#index'
  get 'faq' => 'static#faq'
  get 'imprint' => 'static#contactimprint'

  # Controllers
  get 'projects/charities'
  resources :projects do
    scope :helpers do
      get 'confirm/:confirmation_key' => 'helpers#confirm', as: :helpers_confirm
      get 'unsubscribe' => 'helpers#unsubscribe', as: :helpers_unsubscribe
      get 'subscribe_many' => 'helpers#subscribe_many', as: :helpers_subscribe_many
      post 'subscribe_many' => 'helpers#subscribe_many_post', as: :helpers_subscribe_many_post
      get 'unsubscribe_many' => 'helpers#unsubscribe_many', as: :helpers_unsubscribe_many
      post 'unsubscribe_many' => 'helpers#unsubscribe_many_post', as: :helpers_unsubscribe_many_post
    end
    resources :helpers
    resources :managers

    resources :requests do
      get 'accept'
      get 'decline'
    end
  end

  if ENV['ENABLE_ADMIN'] == "TRUE"
    # Sidekiq
    require 'sidekiq/web'
    mount Sidekiq::Web => '/admin/sidekiq'
    # Admin
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  devise_for :managers, controllers: {
                 confirmations: 'managers/confirmations',
                 sessions: 'managers/sessions'
               }

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
