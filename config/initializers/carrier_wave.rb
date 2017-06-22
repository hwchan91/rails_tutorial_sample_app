if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAIEI3JW7PL5DTZ74Q'],
      :aws_secret_access_key => ENV['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'],
      :region                => ENV['ap-northeast-1']
      }
    config.fog_directory     =  ENV['railstutorial.hwchan91']
  end
end
