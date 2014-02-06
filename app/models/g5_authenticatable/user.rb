module G5Authenticatable
  class User < ActiveRecord::Base
    devise :g5_authenticatable, :trackable, :timeoutable

    validates :email, presence: true, uniqueness: true
    validates_uniqueness_of :uid, scope: :provider
  end
end
