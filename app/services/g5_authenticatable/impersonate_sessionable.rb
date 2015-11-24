module G5Authenticatable
  module ImpersonateSessionable
    extend ActiveSupport::Concern

    private

    def impersonation_user?
      impersonation_user.present?
    end

    def impersonation_user
      user_by_uid(impersonate_admin_uid)
    end

    def clear_impersonation_keys
      clear_impersonated_admin_id
      clear_impersonating_user_uid
    end

    def user_to_impersonate
      user_by_uid(impersonating_user_uid)
    end

    # Checks if the user by param is able to impersonate the second user by param
    def able_to_impersonate?(user_impersonating, resource)
      return false unless user_impersonating.present? && resource.present?
      if user_impersonating.has_role?(:super_admin) ||
         (user_impersonating.has_role?(:admin) && !resource.has_role?(:super_admin))
        true
      else
        false
      end
    end

    def user_by_uid(uid)
      G5Authenticatable::User.find_by_uid(uid)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    # Let's just keep this key secret. you know.. for security reasons.
    IMPERSONATE_SESSION_KEY = 'devise.g5_authenticatable.Xf1eP3hCjC'
    IMPERSONATING_USER_SESSION_KEY = 'devise.g5_authenticatable.Zk35J5adER'

    def impersonate_admin_uid
      request.env['rack.session'][IMPERSONATE_SESSION_KEY]
    end

    def impersonate_admin_uid=(uid)
      request.env['rack.session'][IMPERSONATE_SESSION_KEY] = uid
    end

    def impersonate_admin_uid?
      request.env['rack.session'] && request.env['rack.session'][IMPERSONATE_SESSION_KEY].present?
    end

    def impersonating_user_uid
      request.env['rack.session'][IMPERSONATING_USER_SESSION_KEY]
    end

    def impersonating_user_uid=(uid)
      request.env['rack.session'][IMPERSONATING_USER_SESSION_KEY] = uid
    end

    def impersonating_user_uid?
      request.env['rack.session'] && request.env['rack.session'][IMPERSONATING_USER_SESSION_KEY].present?
    end

    def clear_impersonated_admin_id
      request.env['rack.session'][IMPERSONATE_SESSION_KEY] = nil
    end

    def clear_impersonating_user_uid
      request.env['rack.session'][IMPERSONATING_USER_SESSION_KEY] = nil
    end
  end
end
