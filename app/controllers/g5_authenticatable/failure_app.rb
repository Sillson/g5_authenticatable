class G5Authenticatable::FailureApp < Devise::FailureApp
  def scope_url
    opts  = {}
    route = :"new_#{scope}_session_url"
    opts[:format] = request_format unless skip_format?

    config = Rails.application.config
    # In Devise::FailureApp, the following line is implemented as
    # opts[:script_name] = (config.relative_url_root if config.respond_to?(:relative_url_root))
    # However, in Rails 4.2, passing in {:script_name => nil} to a route helper will override all
    # prefixing logic, including the engine namespace.
    # In other words, g5_authenticatable.new_user_session_path always returns "/g5_auth/users/sign_in".
    # In Rails <= 4.1, g5_authenticatable.new_user_session_path(script_name: nil) also returns 
    # "/g5_auth/users/sign_in", but in Rails 4.2, it returns "/users/sign_in", which isn't
    # actually a route.
    opts[:script_name] = config.relative_url_root if config.try(:relative_url_root)

    context = send(Devise.available_router_name)

    if context.respond_to?(route)
      context.send(route, opts)
    elsif respond_to?(:root_url)
      root_url(opts)
    else
      "/"
    end
  end
end
