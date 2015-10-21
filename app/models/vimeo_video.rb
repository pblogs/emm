class VimeoVideo
  require 'vimeo'
  include ActiveModel::Model
  include ActiveModel::Serialization
  extend ActiveModel::Naming

  attr_accessor :id, :preview, :duration, :duration, :preview

  def initialize(id)
    self.id = id
    info = Vimeo.get_video_info(id)
    return if info.blank?

    if info['error']
      self.errors.add(:base, info['error'])
    else
      self.duration = info.try(:[], 'duration').try(:to_i)
      self.preview = info.try(:[], 'pictures').try(:[], 'sizes').try(:[], 3).try(:[], 'link')
    end
  end

  def make_private!
    Vimeo.make_private(self.id)
  end
end
