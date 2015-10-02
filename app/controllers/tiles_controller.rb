class TilesController < ApplicationController
  load_resource :user
  load_resource :tile, through: :user, only: :update
  authorize_resource

  def index
    tiles = @user.tiles.includes(content: :user).page(params[:page]).per(params[:per_page])
    render_resources(tiles)
  end

  def update
    @tile.update(record_params)
    render_resource_or_errors(@tile)
  end

  private

  def record_params
    params.require(:resource).permit(:weight, :size)
  end
end
