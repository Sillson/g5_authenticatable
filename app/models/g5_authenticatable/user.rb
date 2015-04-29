module G5Authenticatable
  class User < ActiveRecord::Base
    devise :g5_authenticatable, :trackable, :timeoutable

    validates :email, presence: true, uniqueness: true
    validates_uniqueness_of :uid, scope: :provider

    def self.new_with_session(params, session)
      user = super(params, session)
      extended_attributes = extended_auth_attributes(session['omniauth.auth'])
      user.assign_attributes(extended_attributes)
      user
    end

    def self.find_and_update_for_g5_oauth(auth_data)
      user = super(auth_data)
      extended_attributes = extended_auth_attributes(auth_data)
      user.update_attributes(extended_attributes) if user
      user
    end

    private
    def self.extended_auth_attributes(auth_data)
      if auth_data
        extended_attributes = {
          first_name: auth_data.info.first_name,
          last_name: auth_data.info.last_name,
          phone_number: auth_data.info.phone,
          title: auth_data.extra.title,
          organization_name: auth_data.extra.organization_name
        }
      end

      extended_attributes || {}
    end
  end
end
