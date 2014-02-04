require 'rails/generators/base'

module G5Authenticatable
  class InstallGenerator < Rails::Generators::Base
    namespace 'g5_authenticatable'

    desc 'Creates a migration for the user model, copies the locale files,
          and mounts the g5_authenticatable engine.'

    hook_for :orm

    def copy_locale
    end

    def mount_engine
      route "mount G5Authenticatable::Engine => '/g5_auth'"
    end
  end
end
