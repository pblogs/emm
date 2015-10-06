class Users::PasswordsController < ApplicationController
  load_resource :user

  def update
    authorize! :update, @user
    @user.update_with_password update_params
    render_resource_or_errors(@user, serializer: PrivateUserSerializer)
  end

  private

  def update_params
    params.require(:resource).permit(:password, :current_password, :password_confirmation)
  end
end
