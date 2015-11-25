class AlbumsController < ApiController
  include ContentLikes
  include TaggablePermittedParams

  load_resource :user
  load_and_authorize_resource :album, through: :user, except: [:index, :show]
  load_resource :album, through: :user, only: :show

  def index
    if @user == current_user
      albums = @user.albums
    else
      privacy = @user.is_friend?(current_user) ? 'for_friends' : 'for_all'
      albums = @user.albums.by_privacy(privacy)
    end

    render_resources(albums.includes(:tile), with_tile: true, content_likes: get_likes(albums), with_likes: user_signed_in?)
  end

  def show
    render_resource_data(@album, with_tile: true, with_likes: user_signed_in?, invisible_for_you: !can?(:show, @album))
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
    taggable_permitted_params(:title, :description, :cover, :location_name, :latitude, :longitude, :start_date, :color, :privacy, :end_date)
  end

  def records_params
    params.require(:resource).require(:records)
  end
end
