class RelationshipsController < ApplicationController
  authorize_resource

  def index
    case params[:status]
      when 'incoming'
        relationships = current_user.incoming_requests
      when 'outgoing'
        relationships = current_user.outgoing_requests
      when 'users'
        view_user = User.find(params[:user_id])
        relationships = view_user.relations
      else
        relationships = current_user.relations
    end
    render_resources(relationships.includes(:user, :friend).page(params[:page]).per(params[:per]),
                     :scope => view_user || current_user, scope_name: :current_user)
  end

  def update
    relationship = current_user.incoming_requests.find(params[:id])
    relationship.update(status: relationship_params['status'])
    render_resource_or_errors(relationship)
  end

  def create
    friend = User.find(params[:user_id])
    relationship = current_user.relationships.new(friend: friend)
    relationship.save
    render_resource_or_errors(relationship)
  end

  def destroy
    relationship = current_user.relations.find(params[:id])
    relationship.destroy
    render nothing: true
  end

  private

  def relationship_params
    params.require(:resource).permit(:status, :user_id)
  end
end
