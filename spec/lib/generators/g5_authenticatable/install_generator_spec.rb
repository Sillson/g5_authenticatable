require 'spec_helper'

# For some reason, trying to load the generator from this spec
# causes problems without an explicit require statement, even
# though the rails executable is able to find the generator
# when you execute it from the command line
require 'generators/g5_authenticatable/install/install_generator'

describe G5Authenticatable::InstallGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __FILE__)

  before do
    prepare_destination
    setup_routes
    run_generator
  end

  it 'should copy the migration' do
    expect(destination_root).to have_structure {
      directory 'db' do
        directory 'migrate' do
          migration 'create_g5_authenticatable_users' do
            contains 'class CreateG5AuthenticatableUsers < ActiveRecord::Migration'
          end
        end
      end
    }
  end

  it 'should mount the engine' do
    expect(destination_root).to have_structure {
      directory 'config' do
        file 'routes.rb' do
          contains "mount G5Authenticatable::Engine => '/g5_auth'"
        end
      end
    }
  end

  def setup_routes
    routes = <<-END
      Rails.application.routes.draw do
        resource :home, only: [:show, :index]

        match '/some_path', to: 'controller#action', as: :my_alias

        root to: 'home#index'
      end
    END
    config_dir = File.join(destination_root, 'config')

    FileUtils.mkdir_p(config_dir)
    File.write(File.join(config_dir, 'routes.rb'), routes)
  end
end
