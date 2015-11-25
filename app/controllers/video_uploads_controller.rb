class VideoUploadsController < ApiController
  before_action do
    authorize! :upload, Video
  end

  def new
    render_resource_or_errors VimeoUpload.new, serializer: VimeoUploadSerializer
  end

  def create
    video = VimeoUpload.complete(params[:resource][:complete_uri])
    render_resource_or_errors video, serializer: VimeoVideoSerializer
  end
end
