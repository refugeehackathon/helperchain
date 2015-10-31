Rails.application.routes.draw do

  # Static stuff
  root 'static#index'
  get 'faq' => 'static#faq'
  get 'imprint' => 'static#contactimprint'

  # Controllers
  resources :organizations
  resources :requests
  scope :helpers do
    get 'confirm/:confirmation_key' => 'helpers#confirm', as: :helpers_confirm
    get 'unsubscribe' => 'helpers#delete', as: :helpers_unsubscribe
  end
  resources :helpers

  # Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :orga_members

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
