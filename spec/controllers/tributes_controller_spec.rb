require 'rails_helper'

RSpec.describe TributesController, type: :controller do
  login_user

  let(:author) { create(:user) }
  let!(:tribute) { create_list(:tribute, 2, user: @user, author: author).first }
  let(:another_user) { create(:user, :confirmed) }

  describe 'likes' do
    let!(:like) { tribute.likes.create(user: @user) }

    it 'should have like on index' do
      get :index, user_id: @user.id, user_token: @user_token
      expect(json_response['resources'].map { |tribute| tribute['like']}.compact.count).to eq(@user.likes.count)
    end

    it 'should have like on show' do
      get :show, id: tribute.id, user_token: @user_token, user_id: @user.id
      expect(json_response['resource']['like']['id']).to eq(like.id)
    end
  end

  describe '#index' do
    it 'should response success' do
      get :index, user_id: @user.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'should return correct tributes count' do
      get :index, user_id: @user.id, user_token: @user_token
      expect(json_response['meta']['total']).to eq @user.tributes.count
    end

    it 'access denied' do
      get :index, user_id: @user.id
      expect(response).to be_forbidden
    end
  end

  describe '#show' do
    it 'should response success' do
      get :show, id: tribute.id, user_token: @user_token, user_id: @user.id
      expect(response).to be_success
    end

    it 'should respond with tribute data' do
      get :show, id: tribute.id, user_token: @user_token, user_id: @user.id
      tribute = Tribute.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(tribute, nil, @user, with_likes: true).keys)
    end

    it 'should response success if has tile' do
      tribute.create_tile_on_user_page
      get :show, id: tribute.id, user_token: @user_token, user_id: @user.id
      expect(response).to be_success
    end

    it 'access denied for another user' do
      get :show, id: tribute.id, user_token: another_user.jwt_token, user_id: @user.id
      expect(response).to be_forbidden
    end

    it 'access denied' do
      get :show, id: tribute.id, user_id: @user.id
      expect(response).to be_forbidden
    end
  end

  describe '#create' do
    let(:create_attributes) { attributes_for(:tribute) }
    let(:receiver) { create(:user) }
    let(:tribute) { create(:tribute, user: receiver, author: @user) }

    it 'should response success' do
      post :create, user_id: receiver.id, author_id: @user.id, user_token: @user_token, resource: create_attributes
      expect(response).to be_success
    end

    it 'should create tribute' do
      expect {
        post :create, user_id: receiver.id, user_token: @user_token, resource: create_attributes
      }.to change(Tribute, :count).by 1
    end

    it 'should respond with tribute data' do
      post :create, user_id: receiver.id, user_token: @user_token, resource: create_attributes
      tribute = Tribute.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(tribute).keys)
    end

    it 'access denied' do
      post :create, user_id: receiver.id, resource: create_attributes
      expect(response).to be_forbidden
    end
  end
end
