class PhotosController < ApplicationController
  load_resource :album, through: :current_user
  load_resource :photo, through: :album
  authorize_resource

  def show
    render_resource_data(@photo, with_likes: user_signed_in?)
  end

  def create
    @photo.save
    render_resource_or_errors(@photo, with_tile: true, with_record: true)
  end

  def update
    @photo.update(photo_params)
    render_resource_or_errors(@photo)
  end

  def destroy
    @photo.destroy
    render nothing: true
  end

  private

  def photo_params
    params.require(:resource).permit(:album_id, :title, :description, :image)
  end
end
