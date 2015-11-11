class TilesController < ApplicationController
  before_action :load_target, only: :create
  load_resource :page, except: :create
  load_resource :tile, through: :page, except: :create
  authorize_resource

  def create
    page = Page.find(record_params[:page_id]) if record_params[:page_id]
    tile = @target.class.name == 'Relationship' ? @target.show_tile_on_user_page(current_user, page) :  @target.create_tile_on_user_page(page)
    render_resource_or_errors(tile)
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
    params.require(:resource).permit(:size, :page_id)
  end
end
