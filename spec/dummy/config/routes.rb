Rails.application.routes.draw do
  resource :home, only: [:index, :show]

  get '/protected_page', to: 'home#show', as: :protected_page

  mount G5Authenticatable::Engine => '/g5_auth'
  mount SecureApi => '/api'

  root to: 'home#index'
end
