module G5Authenticatable
  class User < ActiveRecord::Base
    devise :g5_authenticatable, :trackable, :timeoutable
    rolify role_cname: 'G5Authenticatable::Role',
           role_join_table_name: :g5_authenticatable_users_roles

    validates :email, presence: true, uniqueness: true
    validates_uniqueness_of :uid, scope: :provider

    def self.new_with_session(params, session)
      user = super(params, session)
      auth_data = session['omniauth.auth']

      if auth_data
        user.assign_attributes(extended_auth_attributes(auth_data))
        user.update_roles_from_auth(auth_data)
      end

      user
    end

    def self.find_and_update_for_g5_oauth(auth_data)
      user = super(auth_data)

      if user
        user.update_attributes(extended_auth_attributes(auth_data))
        user.update_roles_from_auth(auth_data)
      end

      user
    end

    def update_roles_from_auth(auth_data)
      roles.clear
      auth_data.extra.roles.each do |role|
        if(role.type == 'GLOBAL')
          add_role(role.name)
        else
          begin
            the_class = Object.const_get(role.type)
            resource = the_class.where(urn: role.urn).first
            add_role(role.name, resource)
          rescue => e
            Rails.logger.error(e)
          end
        end
      end
    end

    def clients
      return G5Updatable::Client.all if has_global_role
      G5Updatable::Client.where(id: client_roles.map(&:resource_id))
    end

    def client_roles
      G5Authenticatable::Role.joins('INNER JOIN g5_updatable_clients ON g5_updatable_clients.id = g5_authenticatable_roles.resource_id')
        .where('g5_authenticatable_roles.resource_type = ?', G5Updatable::Client.name)
    end

    def has_global_role
      has_role?(:admin) ||
        has_role?(:super_admin) ||
        has_role?(:editor) ||
        has_role?(:viewer)
    end

    private
    def self.extended_auth_attributes(auth_data)
      {
        first_name: auth_data.info.first_name,
        last_name: auth_data.info.last_name,
        phone_number: auth_data.info.phone,
        title: auth_data.extra.title,
        organization_name: auth_data.extra.organization_name
      }
    end



  end
end
