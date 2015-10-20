class UsersSearchController < ApplicationController
  def index
    result = User.search_by_filter(params['filter'])
    render_resources(result.page(params[:page]).per(params[:per]))
  end
end
