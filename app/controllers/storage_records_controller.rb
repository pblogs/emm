class StorageRecordsController < ApiController
  authorize_resource class: false

  def index
    storage = current_user.storage
    render_resources(storage.tiles)
  end

  def create
    tile = Tile.find(params[:tile_id])
    tile.move_to_storage
    render_resource_or_errors(tile)
  end
end
