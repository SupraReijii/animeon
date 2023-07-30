require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Animeon
  class Application < Rails::Application
    config.load_defaults 6.1
    config.autoload_paths << "#{config.root}/app/*"

    config.time_zone = 'Europe/Moscow'
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
