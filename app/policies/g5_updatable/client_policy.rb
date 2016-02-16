module G5Updatable
  class ClientPolicy < G5Authenticatable::BasePolicy
    class Scope < G5Authenticatable::BasePolicy::BaseScope

      def resolve
        return scope.all if has_global_role?
        scope.where(id: client_roles.map(&:resource_id))
      end

      def client_roles
        G5Authenticatable::Role
          .joins('INNER JOIN g5_updatable_clients as c ON c.id = g5_authenticatable_roles.resource_id')
          .joins('INNER JOIN g5_authenticatable_users_roles as ur ON g5_authenticatable_roles.id = ur.role_id')
          .where('g5_authenticatable_roles.resource_type = ? and ur.user_id = ?', G5Updatable::Client.name, user.id)
      end

      def clients_from_client_and_location_roles
        resolve | G5Updatable::LocationPolicy::Scope.new(user, G5Updatable::Location).clients_from_location_roles
      end

      def has_global_role?
        G5Authenticatable::BasePolicy.new(user, G5Updatable::Client).has_global_role?
      end
    end

  end
end
