class MainPageController < ApplicationController
  def index
    tiles = Tile.where(content_type: %W{ Photo Video Text Album }).includes(content: :user)
                .order(created_at: :desc).page(params[:page]).per(params[:per_page])
    render_resources(tiles)
  end
end
