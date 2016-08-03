

# works with tmp dir on heroku and locally.
# CarrierWave.configure do |config|
#   config.cache_dir = "#{Rails.root}/tmp/uploads"
# end
CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp') # adding these...
  # config.cache_dir = 'carrierwave' # ...two lines
  # config.cache_dir = "#{Rails.root}/tmp/uploads"

  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],                        # required
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']                        # required
    # region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
    # host:                  's3.example.com',             # optional, defaults to nil
    # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = 'karmagrove'                          # required
  # config.fog_public     = false                                   # optional, defaults to true
  # config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {} # optional, defaults to {}

  if Rails.env.test? || Rails.env.cucumber?
    # config.storage = :file
    # config.enable_processing = false
    # config.root = "#{Rails.root}/tmp"
     # config.cache_dir = "#{Rails.root}/tmp/uploads"
  else
    config.storage = :fog
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku

  # config.fog_directory    = ENV['S3_BUCKET_NAME']
  # config.s3_access_policy = :public_read                          # Generate http:// urls. Defaults to :authenticated_read (https://)
  # config.fog_host = "#{ENV['S3_ASSET_URL']}/#{ENV['S3_BUCKET_NAME']}"

end


# CarrierWave.configure do |config|
#   config.fog_provider = 'fog/aws'                        # required
#   config.fog_credentials = {
#     provider:              'AWS',                        # required
#     aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],                        # required
#     aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']                        # required
#     # region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
#     # host:                  's3.example.com',             # optional, defaults to nil
#     # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
#   }
#   config.fog_directory  = 'karmagrove'                          # required
#   # config.fog_public     = false                                   # optional, defaults to true
#   config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
# end