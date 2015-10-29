class CommentsController < ApplicationController
  include ContentLikes

  before_action :load_target
  before_action :authorize, only: [:index, :show, :create]

  load_resource through: :target
  authorize_resource only: [:update, :destroy]

  def index
    comments = @comments.includes(:author)

    render_resources(comments, content_likes: get_likes(comments), with_likes: user_signed_in?)
  end

  def show
    render_resource_data(@comment, with_likes: user_signed_in?)
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

  def authorize
    target = @target.try(:album) || @target
    authorize! :show, target
  end
end
