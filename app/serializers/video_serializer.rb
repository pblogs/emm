class VideoSerializer < ContentSerializer
  attributes :preview_url, :video_id, :source

  def preview_url
    object.preview
  end
end
