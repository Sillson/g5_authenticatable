G5Authenticatable::Engine.routes.draw do
  devise_for :users, class_name: 'G5Authenticatable::User',
                     module: :devise,
                     controllers: {sessions: 'g5_authenticatable/sessions'}

  devise_scope :user do
    delete '/users/sign_out', to: 'sessions#destroy'
  end

  get '/auth_error', to: 'error#auth_error'
end
