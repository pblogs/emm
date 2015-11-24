class NewsFeedsController < ApiController
  include ContentLikes
  authorize_resource class: false

  def index
    friends_ids = current_user.friends.pluck(:id)
    tiles_ids = Tile.unscoped.where(content_type: %W{ Photo Video Text Album Relationship })
                  .joins(:page).where(pages: { user_id: friends_ids })
                  .select('max(tiles.id) AS id, max(tiles.created_at) as tile_created_at, CONCAT(content_id, content_type) AS tile_scope')
                  .group(:tile_scope).order('tile_created_at DESC').page(params[:page]).per(params[:per_page]).map(&:id)

    tiles = Tile.unscoped.where(id: tiles_ids).includes(:content).order(created_at: :desc)

    Tile.preload(tiles)

    render_resources tiles, content_likes: get_likes(tiles.map(&:content)), with_likes: user_signed_in?, news_feed: true,
                     each_serializer: TileSimpleSerializer
  end
end
