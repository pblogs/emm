class TagsController < ApplicationController
  before_action :load_and_authorize_target
  load_and_authorize_resource through: :target

  def index
    render_resources @tags.includes(:author, :user)
  end

  def create
    @tag.author = current_user
    @tag.save
    render_resource_or_errors @tag
  end

  def destroy
    @tag.destroy
    render nothing: true
  end

  private

  def load_and_authorize_target
    @target = params[:target_type].camelize.singularize.constantize.find(params[:target_id])
    authorize! :show, @target
  end

  def tag_params
    params.require(:resource).permit(:user_id)
  end
end
