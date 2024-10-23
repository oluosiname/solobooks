# frozen_string_literal: true

Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger]
  config.dsn = ENV['SENTRY_DSN']
  config.enable_tracing = true
  config.enabled_environments = %w[production staging]
  # config.traces_sample_rate = 1.0
  # config.profiles_sample_rate = 1.0
  config.environment = ENV['SOLOBOOKS_ENV']
end
