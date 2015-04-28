module G5Authenticatable
  class User < ActiveRecord::Base
    devise :g5_authenticatable, :trackable, :timeoutable

    validates :email, presence: true, uniqueness: true
    validates_uniqueness_of :uid, scope: :provider

    def self.new_with_session(params, session)
      user = super(params, session)

      if auth_data = session['omniauth.auth']
        user.assign_attributes(
          first_name: auth_data.info.first_name,
          last_name: auth_data.info.last_name,
          phone_number: auth_data.info.phone,
          title: auth_data.extra.title,
          organization_name: auth_data.extra.organization_name
        )
      end

      user
    end
  end
end
