class Video < ActiveRecord::Base
  require 'vimeo'
  include AlbumRecord

  enum source: {vimeo: 0, youtube: 1}

  # Validations
  validates :album, :video_id, :source, presence: true

  # Callbacks
  after_destroy :clear_uploaded, if: :vimeo?

  # Uploaders
  mount_uploader :preview, PhotoUploader

  # Retrieves meta info for vimeo videos and updates preview and duration.
  # Returns true if update was successful, otherwise returns false
  def update_meta_info!
    if self.video_id.present? && self.vimeo?
      vimeo_video = VimeoVideo.new(self.video_id)
      if vimeo_video.preview || vimeo_video.duration
        return self.update(remote_preview_url: vimeo_video.preview, duration: vimeo_video.duration)
      end
    end
    false
  end

  private

  def clear_uploaded
    Vimeo.delete_video(self.video_id)
  end
end
