Rails.application.routes.draw do
  resource :home, only: [:index, :show]

  get '/protected_page', to: 'home#show', as: :protected_page

  root to: 'home#index'
end
