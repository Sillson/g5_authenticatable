G5Authenticatable::Engine.routes.draw do
  devise_for :users, class_name: 'G5Authenticatable::User',
                     module: :devise
end
