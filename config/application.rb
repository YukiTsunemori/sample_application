# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.time_zone = 'Tokyo'
    config.active_storage.variant_processor = :mini_magick
    config.assets.paths << Rails.root.join("vendor", "assets", "stylesheets")

  end
end
