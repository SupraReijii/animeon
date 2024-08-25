# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'aws-sdk-core'

Bundler.require(*Rails.groups)

module Animeon
  class Application < Rails::Application
    config.action_dispatch.default_headers.merge!({
                                                    'Access-Control-Allow-Origin' => '*',
                                                    'Access-Control-Request-Method' => '*'
                                                  })
    Aws.config.update(
      credentials: Aws::Credentials.new(ENV['access_key_id'], ENV['secret_access_key']),
      region: ENV['region'],
      endpoint: ENV['endpoint']
    )
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
  end
end
