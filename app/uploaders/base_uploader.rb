# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  process convert: 'jpg'

  def store_dir
    "uploads/#{Rails.env.test? ? 'test/' : ''}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id/100}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
