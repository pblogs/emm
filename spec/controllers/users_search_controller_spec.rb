require 'rails_helper'

RSpec.describe UsersSearchController, type: :controller do
  login_user

  let(:user) { create(:user, :confirmed, :with_relations) }

  describe '#index' do
    it 'should response success' do
      get :index, user_token: user.jwt_token, filter: @user.first_name
      expect(response).to be_success
    end

    it 'should filter users' do
      get :index, user_token: @user_token, filter: @user.first_name
      expect(json_response['meta']['total']).to eq(1)
    end
  end
end
