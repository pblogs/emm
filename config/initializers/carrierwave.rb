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

  module Uploader
    module Serialization
      extend ActiveSupport::Concern

      def as_json(options=nil)
        return nil unless self.present?
        self.versions.each_with_object({original: self.url}) do |(version_name, version), result|
          result[version_name] = version.url
        end
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
