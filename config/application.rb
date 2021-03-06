require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Coordinate
  class Application < Rails::Application

    #See in config/local_env.yml
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      env_content = YAML.load(File.open(env_file)) if File.exists?(env_file)
      env_content.each do |key, value|
        ENV[key.to_s] = value
      end if env_content
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    I18n.enforce_available_locales = true;
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.assets.paths << "#{Rails}/vendor/assets/fonts"
    config.time_zone = 'UTC'
    config.autoload_paths += Dir["#{config.root}/lib/**/"]  
  end
end
