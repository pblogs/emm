class PagesController < ApplicationController
  load_resource :user
  load_and_authorize_resource :page, through: :user

  def index
    render_resources(@pages)
  end

  def show
    render_resource_data(@page, with_tiles: true)
  end

  def update_tiles
    @page = @user.pages.find(params[:page_id])
    size_enum_code = Tile.screen_sizes[params[:screen_size]]
    mass_update_params = tiles_params.each_with_object({}) do |tile, result|
      result[tile[:id]] = tile.slice(:row, :col).merge({size: Tile.sizes[tile[:size]], screen_size: size_enum_code})
    end
    Tile.mass_update mass_update_params, {page_id: @page.id}
    render_resource_data(@page.reload, with_tiles: true)
  end

  private

  def tiles_params
    params.require(:resource).require(:tiles)
  end
end
