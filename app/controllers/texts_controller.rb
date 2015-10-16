class TextsController < ApplicationController
  load_resource :album, through: :current_user
  load_resource :text, through: :album
  authorize_resource

  def show
    render_resource_data(@text)
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
    params.require(:resource).permit(:album_id, :title, :description)
  end
end
