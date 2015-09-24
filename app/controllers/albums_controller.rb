class AlbumsController < ApplicationController
  load_and_authorize_resource

  def index
    render_resources(@albums)
  end

  def show
    render_resource_data(@album)
  end

  def create
    @album.save
    render_resource_or_errors(@album)
  end

  def update
    @album.update(album_params)
    render_resource_or_errors(@album)
  end

  def destroy
    @album.destroy
    render nothing: true
  end

  private

  def album_params
    params.require(:resource).permit(:title, :description, :cover, :location_name, :latitude, :longitude,
                                     :start_date, :end_date)
  end
end
