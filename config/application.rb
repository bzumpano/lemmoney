require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lemmoney
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.test_framework :rspec
      g.template_engine :haml
      g.view_specs false
      g.request_specs false
      g.controller_specs true

      g.assets = false
      g.helper = false
    end

    config.encoding = 'utf-8'
    config.i18n.default_locale = 'pt-BR'
    config.time_zone = 'Brasilia'

    # Carrega os locales separados em vários arquivos
    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s
    ]
  end
end
