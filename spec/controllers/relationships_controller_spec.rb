require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  login_user

  describe '#index' do
    let(:some_user) { create(:user, :confirmed, :with_relations) }

    it 'should respond success' do
      get :index, user_id: some_user.id
      expect(response).to be_success
    end

    it "should return user's relations" do
      get :index, user_id: some_user.id
      expect(json_response['resources'].map { |f| f['id'] }).to eq(some_user.related_users.map(&:id))
    end

    it 'should return existing friends' do
      get :index, user_id: some_user.id, status: 'friends'
      expect(json_response['resources'].map { |f| f['id'] }).to eq(some_user.friends.map(&:id))
    end

    it 'should return incoming friends' do
      get :index, user_id: some_user.id, status: 'incoming'
      expect(json_response['resources'].map { |f| f['id'] }).to eq(some_user.incoming_friends.map(&:id))
    end

    it 'should return outgoing friends' do
      get :index, user_id: some_user.id, status: 'outgoing'
      expect(json_response['resources'].map { |f| f['id'] }).to eq(some_user.outgoing_friends.map(&:id))
    end

    it 'should return relation status of each user relatively to current user' do
      statuses = %w[pending accepted declined]
      some_user.related_users.first(3).each_with_index do |u, i|
        create(:relationship, sender: @user, recipient: u, status: statuses[i])
      end
      get :index, user_id: some_user.id, user_token: @user_token
      expect(json_response['resources'][0..2].map { |f| f['relation_status'] }).to eq(%w[outgoing_request_pending friends outgoing_request_declined])
    end
  end

  describe '#create' do
    let(:some_user) { create(:user, :confirmed) }
    subject { post :create, user_id: some_user.id, user_token: @user_token }

    it 'should respond success' do
      subject
      expect(response).to be_success
    end

    it "should increase current current users's outgoing requests count" do
      expect { subject }.to change { @user.outgoing_relationships.count }.by 1
    end

    it "user should increase other user's incoming requests count" do
      expect { subject }.to change { some_user.incoming_relationships.count }.by 1
    end

    context 'guest user' do
      it 'response should be forbidden' do
        post :create, user_id: some_user.id
        expect(response).to be_forbidden
      end
    end
  end

  describe '#update' do
    let(:some_user) { create(:user, :confirmed) }
    let!(:relationship) { create :relationship, sender: some_user, recipient: @user }
    subject { put :update, user_id: some_user.id, resource: {status: 'accepted'}, user_token: @user_token }

    it 'should respond success' do
      subject
      expect(response).to be_success
    end

    it 'should change relationship status' do
      subject
      expect(relationship.reload.status).to eq 'accepted'
    end

    it "should increase current user's friends count" do
      expect { subject }.to change { @user.friends.count }.by 1
    end

    it "should increase some user's friends count" do
      expect { subject }.to change { some_user.friends.count }.by 1
    end

    context 'guest user' do
      it 'response should be forbidden' do
        put :update, user_id: some_user.id, resource: {status: 'accepted'}
        expect(response).to be_forbidden
      end
    end
  end

  describe '#destroy' do
    let(:some_user) { create(:user, :confirmed) }
    let!(:relationship) { create :relationship, sender: some_user, recipient: @user }
    subject { delete :destroy, user_id: some_user.id, user_token: @user_token }

    it 'should respond success' do
      subject
      expect(response).to be_success
    end

    it 'should destroy relationship' do
      expect { subject }.to change { Relationship.count }.by -1
    end

    it "should decrease current user's relationships count" do
      expect { subject }.to change { @user.relationships.count }.by -1
    end

    it "should decrease some user's relationships count" do
      expect { subject }.to change { some_user.relationships.count }.by -1
    end

    context 'guest user' do
      it 'response should be forbidden' do
        delete :destroy, user_id: some_user.id
        expect(response).to be_forbidden
      end
    end
  end
end
