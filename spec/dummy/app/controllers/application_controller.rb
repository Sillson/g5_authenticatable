class ApplicationController < ActionController::Base
  include G5Authenticatable::Authorization
  protect_from_forgery
end
