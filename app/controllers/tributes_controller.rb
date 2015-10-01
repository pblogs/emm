class TributesController < ApplicationController
  load_resource except: :create
  load_resource :user, only: :create
  load_resource :tribute, through: :user, only: :create

  authorize_resource

  def index
    render_resources(@tributes)
  end

  def show
    render_resource_data(@tribute)
  end

  def create
    authorize! :create, @tribute

    @tribute.save
    render_resource_or_errors(@tribute)
  end

  private

  def tribute_params
    params.require(:resource).permit(:title, :description, :user_id)
  end
end
