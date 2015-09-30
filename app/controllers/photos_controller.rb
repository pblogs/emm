class PhotosController < ApplicationController
  load_resource :album, through: :current_user
  load_resource :photo, through: :album
  authorize_resource

  def show
    render_resource_data(@photo)
  end

  def create
    @photo.save
    render_resource_or_errors(@photo)
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
    params.require(:resource).permit(:title, :description, :image)
  end
end
