# frozen_string_literal: true

if Rails.env.production?
  require "carrierwave/storage/fog"

  # Setup CarrierWave to use Amazon S3. Add `gem "fog-aws" to your Gemfile.
  #
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                                             # required
    config.fog_credentials = {
      provider:              'AWS',                                             # required
      aws_access_key_id:     Rails.application.secrets.aws_access_key_id,       # required
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,   # required
    }
    config.fog_directory  = 'decidim-lisboa'                                    # required
    config.fog_public     = true                                                # optional, defaults to true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }    # optional, defaults to {}
    config.storage = :fog
  end
else
  CarrierWave.configure do |config|
    config.permissions = 0o666
    config.directory_permissions = 0o777
    config.storage = :file
    config.enable_processing = !Rails.env.test?
  end
end
