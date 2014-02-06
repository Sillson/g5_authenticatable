require 'rails/generators/base'

module G5Authenticatable
  class InstallGenerator < Rails::Generators::Base
    namespace 'g5_authenticatable'

    desc 'Installs the g5_authenticatable engine.'

    def mount_engine
      route "mount G5Authenticatable::Engine => '/g5_auth'"
    end
  end
end
