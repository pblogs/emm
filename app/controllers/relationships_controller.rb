class RelationshipsController < ApplicationController
  load_resource :user
  load_and_authorize_resource

  def index
    case params[:status]
      when 'friends'
        users = @user.friends
      when 'incoming'
        users = @user.incoming_friends
      when 'outgoing'
        users = @user.outgoing_friends
      else
        users = @user.related_users
    end
    options = {with_relationship: true, current_user_relationships: current_user.relationships} if user_signed_in?
    render_resources users.search_by_filter(params['filter']).page(params[:page]).per(params[:per_page]), options || {}
  end

  def create
    relationship = current_user.outgoing_relationships.create(recipient: @user)
    render_resource_or_errors(relationship, with_related_user: true)
  end

  def update
    @relationship.update(status: relationship_params[:status])
    render_resource_or_errors(@relationship, with_related_user: true)
  end

  def destroy
    @relationship.destroy
    render nothing: true
  end

  private

  def relationship_params
    return {} if params[:resource].blank?
    params.require(:resource).permit(:status)
  end
end
