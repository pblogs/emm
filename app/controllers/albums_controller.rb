class AlbumsController < ApplicationController
  load_resource :user
  load_and_authorize_resource :album, through: :user
  skip_load_resource :index

  def index
    if @user == current_user
      albums = @user.albums
    else
      privacy = @user.has_friend_access?(current_user) ? 'for_friends' : 'for_all'
      albums = @user.albums.by_privacy(privacy)
    end
    render_resources(albums.includes(:tile), with_tile: true)
  end

  def show
    render_resource_data(@album, with_tile: true)
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

  def update_records
    @album = @user.albums.find(params[:album_id])
    authorize! :update_records, @album
    mass_update_params = records_params.each_with_object({}) do |record, result|
      result[record[:id]] = {weight: record[:weight].to_i}
    end
    Record.mass_update mass_update_params, {album_id: @album.id}
    render_resource_data(@album.reload)
  end

  private

  def album_params
    params.require(:resource).permit(:title, :description, :cover, :location_name, :latitude, :longitude, :start_date,
                                     :color, :privacy, :end_date)
  end

  def records_params
    params.require(:resource).require(:records)
  end
end
