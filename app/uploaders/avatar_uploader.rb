# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  process convert: 'jpg'
  process resize_to_fill: [200, 300]

  version :thumb do
    process resize_to_fill: [100, 100]
  end

  def store_dir
    "uploads/#{Rails.env.test? ? 'test/' : ''}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/100}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
