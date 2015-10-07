class PagesController < ApplicationController
  load_resource :user
  load_and_authorize_resource :page, through: :user

  def index
    render_resources(@pages)
  end

  def show
    @tile.includes(tiles: {content: :user})
  end
end
