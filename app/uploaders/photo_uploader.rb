# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  process convert: 'jpg'
  process resize_to_limit: [900, 600]

  # version :large do
  #   process resize_to_fill: [300, 200]
  # end
  #
  # version :middle do
  #   process resize_to_fill: [300, 100]
  # end
  #
  # version :small do
  #   process resize_to_fill: [150, 100]
  # end

  version :small do
    process resize_to_fill: [150, 100]
  end

  def store_dir
    "uploads/#{Rails.env.test? ? 'test/' : ''}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/100}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
