class TilesController < ApplicationController
  before_action :load_target, only: :create

  load_resource :user
  load_resource :tile, through: :user, only: [:update, :destroy]
  authorize_resource

  def index
    tiles = @user.tiles.includes(content: :user).page(params[:page]).per(params[:per_page])
    render_resources(tiles)
  end

  def create
    @target.create_tile_on_user_page(Tile.sizes[record_params[:size]])
    render_resource_or_errors(@target)
  end

  def update
    @tile.update(record_params)
    render_resource_or_errors(@tile)
  end

  def destroy
    @tile.destroy
    render nothing: true
  end

  private

  def load_target
    @target = params[:target_type].camelize.constantize.find(params[:target_id])
  end

  def record_params
    params.require(:resource).permit(:weight, :size)
  end
end
