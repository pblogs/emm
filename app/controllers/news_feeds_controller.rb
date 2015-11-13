class NewsFeedsController < ApplicationController
  include ContentLikes
  authorize_resource class: false

  def index
    friends_ids = current_user.friends.pluck(:id)
    tiles_ids = Tile.unscoped.where(content_type: %W{ Photo Video Text Album Relationship })
                  .joins(:page).where(pages: { user_id: friends_ids }).order(created_at: :desc)
                  .page(params[:page]).per(params[:per_page]).pluck(:id)

    tiles = Tile.unscoped.where(id: tiles_ids).includes(:content).order(created_at: :desc)

    Tile.preload(tiles)

    render_resources tiles, content_likes: get_likes(tiles.map(&:content)), with_likes: user_signed_in?, news_feed: true,
                     each_serializer: TileSimpleSerializer
  end
end
