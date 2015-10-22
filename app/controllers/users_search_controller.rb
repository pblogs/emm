class UsersSearchController < ApplicationController
  def index
    result = User.search_by_filter(params['filter']).where.not(role: User.roles['admin'])
    statuses = current_user.relationships_statuses
    render_resources(result.page(params[:page]).per(params[:per]), statuses: statuses)
  end
end
