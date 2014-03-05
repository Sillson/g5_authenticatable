module G5Authenticatable
  class SessionsController < DeviseG5Authenticatable::SessionsController
    protected
    def register_resource
      create_resource
      sign_in_resource
    end

    def signed_in_root_path(resource_or_scope)
      main_app.root_path
    end

    def create_resource
      self.resource = G5Authenticatable::User.new_with_session({}, session)
      resource.update_g5_credentials(auth_data)
      resource.save!
    end

    def after_omniauth_failure_path_for(scope)
      auth_error_path
    end
  end
end
