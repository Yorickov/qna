require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.active_job.queue_adapter = :sidekiq

    # use zeitwerk
    config.add_autoload_paths_to_load_path = false

    # attachments will not being overridden
    config.active_storage.replace_on_assign_to_many = false

    # tz and locale
    config.time_zone = 'Europe/Minsk'
    config.i18n.default_locale = :ru

    # config generators for tests
    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end

    # config.action_cable.disable_request_forgery_protection = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
