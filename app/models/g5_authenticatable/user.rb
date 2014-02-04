module G5Authenticatable
  class User < ActiveRecord::Base
    devise :g5_authenticatable, :trackable, :validatable

    validates_uniqueness_of :uid, scope: :provider
  end
end
