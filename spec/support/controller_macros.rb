module ControllerMacros
  def login_user(type = :each)
    before(type) do
      @user = FactoryGirl.create(:user)
      @user.confirm
      @user_token = @user.jwt_token
    end
  end

  def login_admin(type = :each)
    before(type) do
      @user = FactoryGirl.create(:user, role: :admin)
      @user_token = @user.jwt_token
    end
  end
end
