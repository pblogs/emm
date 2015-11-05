class TributesController < ApplicationController
  include ContentLikes
  
  load_resource :user
  load_and_authorize_resource :tribute, through: :user

  def index
    tributes = @tributes.includes(:author, :tile).page(params[:page]).per(params[:per_page])
    render_resources(tributes, content_likes: get_likes(tributes), with_likes: user_signed_in?, with_tile: true)
  end

  def show
    render_resource_data(@tribute, with_likes: user_signed_in?)
  end

  def create
    @tribute.author = current_user
    @tribute.save
    render_resource_or_errors(@tribute, with_likes: user_signed_in?)
  end

  def update
    @tribute.update(tribute_params)
    render_resource_or_errors(@tribute, with_likes: user_signed_in?)
  end

  def destroy
    @tribute.destroy
    render nothing: true
  end

  private

  def tribute_params
    params.require(:resource).permit(:description)
  end
end
