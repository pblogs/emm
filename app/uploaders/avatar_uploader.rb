# encoding: utf-8

class AvatarUploader < BaseUploader
  process resize_to_fill: [360, 490]

  version :thumb do
    process resize_to_fill: [100, 100]
  end
end
