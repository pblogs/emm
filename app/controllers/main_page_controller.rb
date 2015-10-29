class MainPageController < ApplicationController
  include ContentLikes

  def index
    tiles = Tile.where(content_type: %W{ Photo Video Text Album }).includes(content: :user)
                .order(created_at: :desc).page(params[:page]).per(params[:per_page])

    render_resources tiles, content_likes: get_likes(tiles.map(&:content)), with_likes: user_signed_in?, each_serializer: TileSimpleSerializer
  end
end
