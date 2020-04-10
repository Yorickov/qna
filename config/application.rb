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

    # config cache srore
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }

    # cache_servers = %w[redis://cache-01:6379/0 redis://cache-02:6379/0]
    # config.cache_store = :redis_cache_store, {
    #   url: cache_servers,
    #   connect_timeout: 30,
    #   read_timeout: 0.2,
    #   write_timeout: 0.2,
    #   reconnect_attempts: 1,
    #   error_handler: ->(method:, returning:, exception:) {
    #     Raven.capture_exception exception, level: 'warning', tags: {
    #       method: method, returning: returning
    #     }
    #   }
    # }

    # config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    # config.action_cable.disable_request_forgery_protection = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
