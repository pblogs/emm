class RecordsController < ApplicationController
  load_resource :album, through: :current_user
  load_resource :record, through: :album, only: :update
  authorize_resource

  def index
    render_resources(@album.records)
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
