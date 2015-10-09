# encoding: utf-8

class BackgroundUploader < BaseUploader
  process blur: [0, 1.5]
  # process quality: 50
  process resize_to_limit: [1280, 720]
end
