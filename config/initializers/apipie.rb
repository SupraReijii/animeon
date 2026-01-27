Apipie.configure do |config|
  config.app_name                = "Animeon"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api/doc"
  config.show_all_examples       = true
  config.api_routes              = Rails.application.routes
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
