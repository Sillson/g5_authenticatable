module G5Updatable
  class LocationPolicy < G5Authenticatable::BasePolicy
    class Scope < G5Authenticatable::BasePolicy::BaseScope

      def resolve
        return scope.all if has_global_role?
        scope.where(id: location_roles.map(&:resource_id))
      end

      def location_roles
        G5Authenticatable::Role
          .joins('INNER JOIN g5_updatable_locations as l ON l.id = g5_authenticatable_roles.resource_id')
          .joins('INNER JOIN g5_authenticatable_users_roles as ur ON g5_authenticatable_roles.id = ur.role_id')
          .where('g5_authenticatable_roles.resource_type = ? and ur.user_id = ?',
                 G5Updatable::Location.name, user.id)
      end

      def clients_from_location_roles
        G5Updatable::Client
          .joins('INNER JOIN g5_updatable_locations as l on l.client_uid=g5_updatable_clients.uid')
          .joins('INNER JOIN g5_authenticatable_roles as r on l.id=r.resource_id')
          .joins('INNer JOIN g5_authenticatable_users_roles as ur on r.id=ur.role_id')
          .where('r.resource_type = ? and ur.user_id = ?',
                 G5Updatable::Location.name, user.id)
          .group('g5_updatable_clients.id')
      end

      def has_global_role?
        G5Authenticatable::BasePolicy.new(user).has_global_role?
      end
    end

  end
end
