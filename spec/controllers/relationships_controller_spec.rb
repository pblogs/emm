require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  login_user
  let(:friend) { create(:user, :confirmed) }
  let(:user) { create(:user, :confirmed, :with_relations) }

  describe '#index' do
    it 'should response success' do
      get :index, user_id: @user.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'should return incoming requests' do
      get :index, user_id: user.id, user_token: user.jwt_token, status: 'incoming'
      expect(json_response['meta']['total']).to eq(user.incoming_requests.count)
    end

    it 'should return outgoing requests' do
      get :index, user_id: user.id, user_token: user.jwt_token, status: 'outgoing'
      expect(json_response['meta']['total']).to eq(user.outgoing_requests.count)
    end

    it 'should return all accepted relations' do
      get :index, user_id: user.id, user_token: user.jwt_token
      expect(json_response['meta']['total']).to eq(user.relations.count)
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
      }.to change { @user.incoming_requests.count }.by 1
    end

    it 'user should have outgoing request' do
      expect {
        post :create, user_id: friend.id, user_token: @user_token
      }.to change { @user.outgoing_requests.count }.by 1
    end

    it 'response should be forbidden' do
      post :create, user_id: friend.id
      expect(response).to be_forbidden
    end
  end

  describe '#update' do
    let(:incoming_request) { user.incoming_requests.first }
    let(:new_status) { 'accepted' }

    it 'response should be success' do
      put :update, user_id: user.id, id: incoming_request.id, resource: { status: new_status }, user_token: user.jwt_token
      expect(response).to be_success
    end

    it 'changes status' do
      put :update, user_id: user.id, id: incoming_request.id, resource: { status: new_status }, user_token: user.jwt_token
      expect(incoming_request.reload.status).to eq new_status
    end

    it 'access denied' do
      put :update, user_id: user.id, id: incoming_request.id, resource: { status: new_status }
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
      }.to change{user.relations.count}.from(user.relations.count).to(user.relations.count - 1)
    end

    it 'access denied' do
      delete :destroy, id: user.relations.first.id, user_id: user.id
      expect(response).to be_forbidden
    end
  end
end
