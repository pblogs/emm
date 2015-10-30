class TextsController < ApplicationController
  include TaggablePermittedParams

  load_resource :album, through: :current_user
  load_resource :text, through: :album
  authorize_resource

  def show
    render_resource_data(@text, with_likes: user_signed_in?)
  end

  def create
    @text.save
    render_resource_or_errors(@text, with_tile: true, with_record: true)
  end

  def update
    @text.update(text_params)
    render_resource_or_errors(@text)
  end

  def destroy
    @text.destroy
    render nothing: true
  end

  private

  def text_params
    taggable_permitted_params(:album_id, :title, :description)
  end
end
