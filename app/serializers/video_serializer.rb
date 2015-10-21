class VideoSerializer < ContentSerializer
  attributes :preview_url, :video_id, :source, :duration

  def preview_url
    object.preview
  end
end
