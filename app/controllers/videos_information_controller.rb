class VideosInformationController < ApplicationController
  def show
    video_info = VideoInformation.new(params_url)
    render_resource_data video_info.parse, serializer: VideoInformationSerializer
  end

  private

  def params_url
    params[:url]
  end
end
