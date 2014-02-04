Rails.application.routes.draw do

  mount G5Authenticatable::Engine => '/g5_auth'

  resource :home, only: [:index, :show]

  match '/protected_page', to: 'home#show', as: :protected_page

  root to: 'home#index'
end
