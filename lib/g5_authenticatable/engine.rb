module G5Authenticatable
  class Engine < ::Rails::Engine
    isolate_namespace G5Authenticatable

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    generators do
      require 'generators/g5_authenticatable/install_generator'
    end
  end
end
