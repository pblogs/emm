class TilesController < ApplicationController
  before_action :load_target, only: :create
  load_resource :page, except: :create
  load_resource :tile, through: :page, except: :create
  authorize_resource

  def create
    @target.create_tile_on_user_page(record_params[:page])
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
    params.require(:resource).permit(:size)
  end
end
