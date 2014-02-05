G5Authenticatable::Engine.routes.draw do
  devise_for :users, class_name: 'G5Authenticatable::User',
                     module: :devise,
                     controllers: {sessions: 'g5_authenticatable/sessions'}
end
