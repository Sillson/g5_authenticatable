Rails.application.routes.draw do
  resource :home, only: [:index, :show]

  get '/protected_page', to: 'home#show', as: :protected_page

  namespace :rails_api do
    resource :secure_resource, only: [:create, :show],
                               defaults: {format: 'json'}
  end

  mount G5Authenticatable::Engine => '/g5_auth'
  mount SecureApi => '/api'

  root to: 'home#index'
end
