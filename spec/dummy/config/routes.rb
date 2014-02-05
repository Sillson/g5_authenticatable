Rails.application.routes.draw do

  mount G5Authenticatable::Engine => "/g5_authenticatable"
end
