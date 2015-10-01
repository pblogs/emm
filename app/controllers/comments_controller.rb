class CommentsController < ApplicationController
  before_action :load_target

  load_and_authorize_resource through: :target

  def index
    render_resources(@comments)
  end

  def show
    render_resource_data(@comment)
  end

  def create
    @comment.author = current_user
    @comment.save
    render_resource_or_errors(@comment)
  end

  def update
    @comment.update(comment_params)
    render_resource_or_errors(@comment)
  end

  def destroy
    @comment.destroy
    render nothing: true
  end

  private

  def load_target
    @target = params[:target_type].camelize.constantize.find(params[:target_id])
  end

  def comment_params
    params.require(:resource).permit(:commentable_id, :commentable_type, :text)
  end
end
