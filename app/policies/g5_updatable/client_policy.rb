module G5Updatable
  class ClientPolicy < G5Authenticatable::BasePolicy
    class Scope < G5Authenticatable::BasePolicy::BaseScope

      def resolve
        return scope.all if has_global_role?
        scope.where(id: client_roles.map(&:resource_id))
      end

      def client_roles
        G5Authenticatable::Role
          .joins('INNER JOIN g5_updatable_clients ON g5_updatable_clients.id = g5_authenticatable_roles.resource_id')
          .joins('INNER JOIN g5_authenticatable_users_roles ON g5_authenticatable_roles.id = g5_authenticatable_users_roles.role_id')
          .where('g5_authenticatable_roles.resource_type = ? and g5_authenticatable_users_roles.user_id = ?', G5Updatable::Client.name, user.id)
      end

      def has_global_role?
        G5Authenticatable::BasePolicy.new(user, G5Updatable::Client).has_global_role?
      end
    end

  end
end
