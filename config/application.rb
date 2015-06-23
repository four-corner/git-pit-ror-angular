require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GitManager
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #config.angular_templates.module_name    = 'templates'
    #config.angular_templates.inside_paths   = [Rails.root.join('app', 'assets', 'angular')]
    #config.angular_templates.ignore_prefix  = %w(templates/)
    #config.angular_templates.markups        = %w(erb haml)
    #config.angular_templates.htmlcompressor = false

    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.assets.precompile.shift

    # Explicitly register the extensions we are interested in compiling
    config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
                                 '.html', '.erb', '.haml',                 # Templates
                                 '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
                                 '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
                             ]
    end)

  end
end
