require 'rails_helper'

RSpec.describe AlbumsController, type: :controller do
  login_user

  let!(:album) { create(:album, user: @user) }

  describe '#index' do
    it 'should response success' do
      get :index, user_id: @user.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'should return correct albums count' do
      get :index, user_id: @user.id, user_token: @user_token
      expect(json_response['meta']['total']).to eq @user.albums.count
    end
  end

  describe '#create' do
    let(:create_attributes) { attributes_for(:album, user: @user) }

    it 'should response success' do
      post :create, user_id: @user.id, user_token: @user_token, resource: create_attributes
      expect(response).to be_success
    end

    it 'should create album' do
      expect {
        post :create, user_id: @user.id, user_token: @user_token, resource: create_attributes
      }.to change(Album, :count).by 1
    end

    it 'should respond with album data' do
      post :create, user_id: @user.id, user_token: @user_token, resource: create_attributes
      album = Album.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(album).keys)
    end

    it 'access denied' do
      post :create, user_id: @user.id, resource: create_attributes
      expect(response).to be_forbidden
    end
  end

  describe '#show' do
    it 'should response success' do
      get :show, id: album.id, user_token: @user_token, user_id: @user.id
      expect(response).to be_success
    end

    it 'should respond with album data' do
      get :show, id: album.id, user_token: @user_token, user_id: @user.id
      album = Album.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(album).keys)
    end
  end

  describe '#update' do
    let(:new_title) { Faker::Lorem.word }

    before(:each) do
      @album = create(:album, user: @user)
    end

    it 'response should be success' do
      put :update, user_id: @user.id, id: @album.id, resource: { title: new_title }, user_token: @user_token
      expect(response).to be_success
    end

    it 'changes album name' do
      put :update, user_id: @user.id, id: @album.id, resource: { title: new_title }, user_token: @user_token
      expect(@album.reload.title).to eq new_title
    end

    it 'should not update another user album' do
      album = create(:album)
      put :update, user_id: @user.id, id: album.id, resource: { title: new_title }, user_token: @user_token
      expect(response).to be_forbidden
    end

    it 'access denied' do
      put :update, user_id: @user.id, id: @album.id, resource: { title: new_title }
      expect(response).to be_forbidden
    end
  end

  describe '#destroy' do
    it 'returns http success' do
      delete :destroy, user_id: @user.id, id: album.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'access denied' do
      delete :destroy, user_id: @user.id, id: album.id
      expect(response).to be_forbidden
    end

    it 'should not delete another user album' do
      album = create(:album)
      delete :destroy, user_id: @user.id, user_token: @user_token, id: album.id
      expect(response).to be_forbidden
    end
  end
end
