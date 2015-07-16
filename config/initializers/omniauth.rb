Rails.application.config.middleware.use OmniAuth::Builder do
  provider :timecrowd,
    Settings.timecrowd.client_id,
    Settings.timecrowd.client_secret,
    client_options: { site: Settings.timecrowd.site, }
end
OmniAuth.config.logger = Rails.logger

