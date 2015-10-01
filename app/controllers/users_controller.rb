class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    render_resources @users
  end

  def show
    @user = params[:page_alias] ? User.find_by_page_alias(params[:page_alias]) : User.find(params[:id])
    serializer = user_signed_in? && current_user.id == @user.id ? PrivateUserSerializer : UserSerializer
    render_resource_data(@user, serializer: serializer)
  end

  def update
    @user.update(user_params)
    render_resource_or_errors(@user)
  end

  def destroy
    @user.destroy
    render(nothing: true)
  end

  private

  def user_params
    params.require(:resource).permit(:email, :first_name, :last_name, :birthday, :avatar, :background)
  end
end
