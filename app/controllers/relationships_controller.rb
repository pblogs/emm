class RelationshipsController < ApplicationController
  load_resource :user
  authorize_resource

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
    opts = user_signed_in? ? {with_relation: true, current_user_relationships: current_user.relationships} : {}
    render_resources users.search_by_filter(params['filter']).page(params[:page]).per(params[:per]), opts
  end

  def update
    relationship = current_user.incoming_relationships.find_by_sender_id!(@user.id)
    relationship.update(status: relationship_params[:status])
    render_resource_or_errors(relationship, with_relation: true, current_user: current_user)
  end

  def create
    relationship = current_user.outgoing_relationships.create(recipient: @user)
    render_resource_or_errors(relationship, with_relation: true, current_user: current_user)
  end

  def destroy
    relationship = current_user.relation_to(@user.id)
    relationship.destroy
    render nothing: true
  end

  private

  def relationship_params
    params.require(:resource).permit(:status)
  end
end
