class VideoSerializer < ContentSerializer
  attributes :preview_url, :video_id

  def preview_url
    object.preview
  end
end
