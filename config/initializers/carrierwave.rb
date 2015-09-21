require 'carrierwave/orm/activerecord'

module CarrierWave
  module MiniMagick
    # Process images with blur effect
    def blur(radius, sigma)
      manipulate! do |img|
        img.blur "#{radius}x#{sigma}"
        img = yield(img) if block_given?
        img
      end
    end

    # Process images with setting JPEG quality
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
