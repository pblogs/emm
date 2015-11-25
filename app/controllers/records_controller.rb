class RecordsController < ApiController
  include ContentLikes

  load_resource :album
  load_and_authorize_resource :record, through: :album, except: :index

  def index
    authorize! :show, @album

    records = @album.records.includes(content: [:user, :tile]).page(params[:page]).per(params[:per_page])
    render_resources(records, content_likes: get_likes(records.map(&:content)), with_tile: true, with_likes: user_signed_in?)
  end

  def update
    @record.update(record_params)
    render_resource_or_errors(@record)
  end

  private

  def record_params
    params.require(:resource).permit(:weight)
  end
end
