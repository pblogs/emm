# encoding: utf-8

class BackgroundUploader < BaseUploader
  process resize_to_limit: [1280, 1024]
end
