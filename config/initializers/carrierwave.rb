require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage :aws
    config.aws_bucket = ENV['AWS_BUCKET']
    config.aws_acl = 'private'
    config.aws_credentials = {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    }
  else
      config.storage = :file
      config.enable_processing = Rails.env.development?
  end
end
