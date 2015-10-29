class CommentsController < ApplicationController
  include ContentLikes

  before_action :load_and_authorize_target
  load_and_authorize_resource through: :target

  def index
    comments = @comments.includes(:author)
    render_resources(comments, content_likes: get_likes(comments), with_likes: user_signed_in?)
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

  def load_and_authorize_target
    @target = params[:target_type].camelize.constantize.find(params[:target_id])
    authorize! :show, @target
  end

  def comment_params
    params.require(:resource).permit(:text)
  end
end
