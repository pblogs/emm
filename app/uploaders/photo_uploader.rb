# encoding: utf-8

class PhotoUploader < BaseUploader
  process resize_to_limit: [900, 600]

  version :small do
    process resize_to_fill: [150, 100]
  end
end
