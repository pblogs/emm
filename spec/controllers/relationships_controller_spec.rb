require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  login_user
  let(:user) { create(:user, :confirmed, :with_relations) }
  let(:friend) { create(:user, :confirmed) }

  describe '#index' do
    it 'should response success' do
      get :index, user_id: user.id
      expect(response).to be_success
    end

    it "should return user's relations" do
      get :index, user_id: user.id
      expect(json_response['resources'].map { |f| f['id'] }).to eq(user.related_users.map(&:id))
    end

    it 'should return existing friends' do
      get :index, user_id: user.id, status: 'friends'
      expect(json_response['resources'].map { |f| f['id'] }).to eq(user.friends.map(&:id))
    end

    it 'should return incoming friends' do
      get :index, user_id: user.id, status: 'incoming'
      expect(json_response['resources'].map { |f| f['id'] }).to eq(user.incoming_friends.map(&:id))
    end

    it 'should return outgoing friends' do
      get :index, user_id: user.id, status: 'outgoing'
      expect(json_response['resources'].map { |f| f['id'] }).to eq(user.outgoing_friends.map(&:id))
    end

    it 'should return relation status of each user relatively to current user' do
      statuses = %w[pending accepted declined]
      user.related_users[0..2].each_with_index do |u, i|
        create(:relationship, sender: @user, recipient: u, status: statuses[i])
      end
      get :index, user_id: user.id, user_token: @user_token
      expect(json_response['resources'][0..2].map { |f| f['relation_status'] }).to eq(%w[outgoing_request_pending friends outgoing_request_declined])
    end
  end

  describe '#create' do
    it 'response should be success' do
      post :create, user_id: friend.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'user should have incoming requests' do
      expect {
        post :create, user_id: @user.id, user_token: friend.jwt_token
      }.to change { @user.incoming_relationships.count }.by 1
    end

    it 'user should have outgoing request' do
      expect {
        post :create, user_id: friend.id, user_token: @user_token
      }.to change { @user.outgoing_relationships.count }.by 1
    end

    it 'response should be forbidden' do
      post :create, user_id: friend.id
      expect(response).to be_forbidden
    end
  end

  describe '#update' do
    let(:incoming_request) { user.incoming_relationships.first }
    let(:new_status) { 'accepted' }

    it 'response should be success' do
      put :update, user_id: user.id, id: incoming_request.id, resource: {status: new_status}, user_token: user.jwt_token
      expect(response).to be_success
    end

    it 'changes status' do
      put :update, user_id: user.id, id: incoming_request.id, resource: {status: new_status}, user_token: user.jwt_token
      expect(incoming_request.reload.status).to eq new_status
    end

    it 'access denied' do
      put :update, user_id: user.id, id: incoming_request.id, resource: {status: new_status}
      expect(response).to be_forbidden
    end
  end

  describe '#destroy' do
    it 'returns http success' do
      delete :destroy, id: user.relations.first.id, user_id: user.id, user_token: user.jwt_token
      expect(response).to be_success
    end

    it 'should destroy relation' do
      expect {
        delete :destroy, id: user.relations.first.id, user_id: user.id, user_token: user.jwt_token
      }.to change { user.relations.count }.from(user.relations.count).to(user.relations.count - 1)
    end

    it 'access denied' do
      delete :destroy, id: user.relations.first.id, user_id: user.id
      expect(response).to be_forbidden
    end
  end
end
