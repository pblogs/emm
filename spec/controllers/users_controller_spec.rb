require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  login_user
  let(:new_user) { create(:user,  :confirmed) }

  context 'accessing user data' do
    describe 'show private data' do
      it 'should response success' do
        get :show, user_token: @user_token, id: @user.id
        expect(response).to be_success
      end

      it 'should respond with user data' do
        get :show, user_token: @user_token, id: @user.id
        @user.reload
        expect(json_response['resource'].keys).to contain_exactly(*serialized(@user, PrivateUserSerializer).keys)
      end
    end

    describe 'show public data' do
      it 'should response success' do
        get :show, user_token: @user_token, id: new_user.id
        expect(response).to be_success
      end

      it 'should respond with user data' do
        get :show, user_token: @user_token, id: new_user.id
        @user.reload
        expect(json_response['resource'].keys).to contain_exactly(*serialized(@user, UserSerializer).keys)
      end
    end
  end

  describe 'Update user' do
    it 'should response success' do
      put :update, id: @user.id, user_token: @user_token, resource: { email: Faker::Internet.email }
      expect(response).to be_success
    end

    it 'should change fields' do
      put :update, id: @user.id, user_token: @user_token, resource: { email: Faker::Internet.email }
      expect(json_response['resource']['email']).to eq(@user.reload.email)
    end

    it 'access denied' do
      put :update, id: new_user.id, user_token: @user_token, resource: { first_name: Faker::Name.first_name }
      expect(response).to be_forbidden
    end
  end

  describe '#destroy' do
    let(:admin) { create(:user,  :confirmed, role: :admin) }

    it 'returns http success' do
      delete :destroy, id: @user.id, user_token: admin.jwt_token
      expect(response).to be_success
    end

    it 'access denied without token' do
      delete :destroy, id: @user.id
      expect(response).to be_forbidden
    end

    it 'should not delete another user' do
      delete :destroy, id: @user.id, user_token: new_user.jwt_token
      expect(response).to be_forbidden
    end
  end
end
