class TributesController < ApplicationController
  include ContentLikes

  load_resource except: :create
  load_resource :user, only: :create
  load_resource :tribute, through: :user, only: :create

  authorize_resource

  def index
    tributes = @tributes.includes(:author)
    render_resources(tributes, content_likes: get_likes(tributes), with_likes: user_signed_in?)
  end

  def show
    render_resource_data(@tribute, with_likes: user_signed_in?)
  end

  def create
    authorize! :create, @tribute

    @tribute.save
    render_resource_or_errors(@tribute)
  end

  private

  def tribute_params
    params.require(:resource).permit(:title, :description, :user_id)
  end
end
