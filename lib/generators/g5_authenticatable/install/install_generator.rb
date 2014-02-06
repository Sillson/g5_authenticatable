class G5Authenticatable::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def mount_engine
    route "mount G5Authenticatable::Engine => '/g5_auth'"
  end
end
