# encoding: utf-8

class PhotoUploader < BaseUploader
  process resize_to_limit: [1280, 1024]

  version :small do
    process resize_to_fill: [352, 352]
  end
end
