require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  login_user
  let(:old_password) { attributes_for(:user)[:password] }
  let(:new_password) { 'newpassword' }

  describe 'PUT #update' do
    it 'return http success' do
      put :update, user_id: @user.id, user_token: @user_token,
          resource: { password: new_password, password_confirmation: new_password, current_password: old_password }
      expect(response).to be_success
    end

    it 'changes password' do
      put :update, user_id: @user.id, user_token: @user_token,
          resource: { password: new_password, password_confirmation: new_password, current_password: old_password }
      expect(@user.reload.valid_password? new_password).to be true
    end

    it 'should not change password with wrong old password' do
      put :update, user_id: @user.id, user_token: @user_token,
          resource: { password: new_password, password_confirmation: new_password, current_password: 'wrong_password' }
      expect(@user.reload.valid_password? new_password).to be false
    end

    it 'user cannot change someone else password' do
      another_user = create :user
      put :update, user_id: another_user.id, user_token: @user_token,
          resource: { password: new_password, password_confirmation: new_password, current_password: old_password }
      expect(response).to be_forbidden
    end
  end
end
