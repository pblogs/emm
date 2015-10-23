class VideoInformationsController < ApplicationController
  def show
    video_info = VideoInformation.new(params[:url])
    render_resource_or_errors video_info.parse, serializer: VideoInformationSerializer
  end
end
