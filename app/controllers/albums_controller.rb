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
    params.require(:resource).permit(:title, :description, :cover, :location_name, :latitude, :longitude, :start_date,
                                     :color, :privacy, :end_date)
  end
end
