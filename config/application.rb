# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'aws-sdk-core'

Bundler.require(*Rails.groups)

module Animeon
  DOMAINS = {
    production: 'animeon.ru',
    development: 'animeon.local',
  }.freeze
  DOMAIN = DOMAINS[Rails.env.to_sym]

  PROTOCOLS = {
    production: 'https',
    development: 'https'
  }.freeze

  PROTOCOL = ENV['IS_LOCAL_RUN'] ? 'https' : PROTOCOLS[Rails.env.to_sym]

  HOST = "#{Animeon::PROTOCOL}://#{Animeon::DOMAIN}".freeze
  PROXY_SUBDOMAIN = 'proxy'
  PROXY = "#{Animeon::PROTOCOL}://#{Animeon::PROXY_SUBDOMAIN}.#{Animeon::DOMAIN}".freeze
  class Application < Rails::Application
    def redis
      Rails.application.config.redis
    end
    Aws.config.update(
      credentials: Aws::Credentials.new(ENV['access_key_id'], ENV['secret_access_key']),
      region: ENV['region'],
      endpoint: ENV['endpoint']
    )

    config.i18n.default_locale = :ru
    config.i18n.locale = :ru
    config.i18n.available_locales = %i[ru en]
    config.load_defaults 7.1
    config.autoload_paths << "#{config.root}/app/*"
    config.autoload_lib(ignore: %w[assets tasks])
    config.generators do |generator|
      generator.template_engine :slim
      generator.stylesheets false
      generator.helper false
      generator.helper_specs false
      generator.view_specs false
      generator.test_framework :rspec
    end
    config.redis = Redis.new(
      host: 'redis',
      port: 6379,
      #password: ENV['REDIS_PASSWORD']
    )
  end
end
