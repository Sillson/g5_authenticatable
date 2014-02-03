module G5Authenticatable
  class User < ActiveRecord::Base
    devise :g5_authenticatable, :trackable
  end
end
