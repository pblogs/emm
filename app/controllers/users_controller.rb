class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    serializer = (user_signed_in? && current_user.id) == params[:id].to_i ? PrivateUserSerializer : UserSerializer
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
    params.require(:resource).permit(:email, :first_name, :last_name, :birthday, :remote_avatar_url)
  end
end
