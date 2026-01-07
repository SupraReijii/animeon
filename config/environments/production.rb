# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = false
  config.active_storage.service = :test
  config.force_ssl = true
  config.hosts << 'animeon.ru'
  config.hosts << 'www.animeon.ru'
  config.hosts << 'animeon.vm'
  config.logger = ActiveSupport::Logger.new($stdout)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [:request_id]
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.default_url_options = {:host => 'animeon.ru'}
  config.action_mailer.default_options = { from: "no-reply@animeon.ru" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.yandex.ru",
    port: 587,
    domain: 'animeon.ru',
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication:  "plain"
  }
end
