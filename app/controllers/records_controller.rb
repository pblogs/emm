class RecordsController < ApplicationController
  load_resource :album
  load_resource :record, through: :album, only: :update
  authorize_resource

  def index
    authorize! :show, @album
    render_resources(@album.records.includes(content: [:user, :tile]).page(params[:page]).per(params[:per_page]), with_tile: true)
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
