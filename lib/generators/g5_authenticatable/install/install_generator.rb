class G5Authenticatable::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  # Required for Rails::Generators::Migrations
  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  def create_users_migration
    filename = 'create_g5_authenticatable_users.rb'
    migration_template filename, "db/migrate/#{filename}"
  end

  def mount_engine
    route "mount G5Authenticatable::Engine => '/g5_auth'"
  end
end
