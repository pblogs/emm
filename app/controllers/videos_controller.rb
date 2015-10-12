class VideosController < ApplicationController
  load_resource :album, through: :current_user
  load_resource :video, through: :album
  authorize_resource

  def show
    render_resource_data(@video)
  end

  def create
    @video.save
    render_resource_or_errors(@video, with_tile: true)
  end

  def update
    @video.update(video_params)
    render_resource_or_errors(@video)
  end

  def destroy
    @video.destroy
    render nothing: true
  end

  private

  def video_params
    params.require(:resource).permit(:title, :description, :preview, :video_id)
  end
end
