class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    users = User.search_by_filter(params['filter']).where.not(role: User.roles['admin'])
    opts = user_signed_in? ? {with_relation: true, current_user_relationships: current_user.relationships} : {}
    render_resources(users.page(params[:page]).per(params[:per]), opts)
  end

  def show
    @user = params[:page_alias] ? User.find_by_page_alias(params[:page_alias]) : User.find(params[:id])
    options = if user_signed_in? && current_user.id == @user.id
                {serializer: PrivateUserSerializer}
              elsif user_signed_in?
                {with_relation: true, current_user: current_user}
              else
                {}
              end
    render_resource_data(@user, options)
  end

  def update
    @user.update(user_params)
    render_resource_or_errors(@user, serializer: PrivateUserSerializer)
  end

  def destroy
    @user.destroy
    render(nothing: true)
  end

  private

  def user_params
    params.require(:resource).permit(:email, :first_name, :last_name, :birthday, :avatar, :remove_avatar, :background, :remove_background)
  end
end
