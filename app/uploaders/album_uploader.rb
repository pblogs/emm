# encoding: utf-8

class AlbumUploader < BaseUploader
  version :thumb do
    process resize_to_fill: [300, 300]
  end
end
