require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  login_user
  let(:new_user) { create(:user, :confirmed) }

  describe '#index' do
    let!(:users) { create_list(:user, 10, :confirmed) }

    it 'should respond with success' do
      get :index
      expect(response).to be_success
    end

    it 'should return correct users count' do
      get :index
      expect(json_response['meta']['total']).to eq User.count
    end

    it 'should apply filter on result' do
      filter_user = create(:user, :confirmed, first_name: 'John', last_name: 'Doe')
      get :index, filter: 'John Doe'
      expect(json_response['resources'][0]['id']).to eq filter_user.id
    end

    it 'should return relation status of each user relatively to current user' do
      statuses = %w[pending accepted declined]
      related_users = users.first(3)
      related_users.each_with_index do |u, i|
        create(:relationship, sender: @user, recipient: u, status: statuses[i])
      end
      get :index, user_token: @user_token
      statuses = json_response['resources']
                     .select { |u| u['id'].in? related_users.map(&:id) }
                     .map { |u| u['relationship']['relation_to_current_user'] }
      expect(statuses).to eq(%w[outgoing_request_pending friends outgoing_request_declined])
    end
  end

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
        expect(json_response['resource'].keys).to contain_exactly(*serialized(@user, UserSerializer, @user, with_relationship: true, current_user: @user).keys)
      end
    end

    describe 'counters' do
      %W{ video photo text }.each do |content_name|
        it "should return correct #{ content_name.pluralize } count" do
          create(content_name, album: @user.default_album)
          get :show, user_token: @admin_token, id: @user.id
          expect(json_response['resource']["#{content_name.pluralize}_count"]).to eq(@user.albums.sum("#{content_name.pluralize}_count"))
        end
      end

      it 'should return correct relationships count' do
        relationship = create(:relationship, sender: @user, recipient: new_user)
        relationship.update(status: 'accepted')

        get :show, user_token: @admin_token, id: @user.id
        expect(json_response['resource']['relationships_count']).to eq(@user.relationships_count)
      end
    end
  end

  describe 'Update user' do
    it 'should response success' do
      put :update, id: @user.id, user_token: @user_token, resource: {email: Faker::Internet.email}
      expect(response).to be_success
    end

    it 'should change fields' do
      put :update, id: @user.id, user_token: @user_token, resource: {email: Faker::Internet.email}
      expect(json_response['resource']['email']).to eq(@user.reload.email)
    end

    it 'access denied' do
      put :update, id: new_user.id, user_token: @user_token, resource: {first_name: Faker::Name.first_name}
      expect(response).to be_forbidden
    end
  end

  describe '#destroy' do
    let(:admin) { create(:user, :confirmed, role: :admin) }

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
