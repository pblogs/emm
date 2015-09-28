require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  login_user

  let(:album) { create(:album, user: @user) }
  let(:photo) { create(:photo, album: album) }

  describe '#create' do
    let(:create_attributes) { attributes_for(:photo) }

    it 'should response success' do
      post :create, album_id: album.id, user_token: @user_token, resource: create_attributes
      expect(response).to be_success
    end

    it 'should create photo' do
      expect {
        post :create, album_id: album.id, user_token: @user_token, resource: create_attributes
      }.to change(Photo, :count).by 1
    end

    it 'should respond with photo data' do
      post :create, album_id: album.id, user_token: @user_token, resource: create_attributes
      photo = Photo.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(photo).keys)
    end

    it 'access denied' do
      post :create, album_id: album.id, resource: create_attributes
      expect(response).to be_forbidden
    end
  end

  describe '#show' do
    it 'should response success' do
      get :show, id: photo.id, user_token: @user_token, album_id: album.id
      expect(response).to be_success
    end

    it 'should respond with photo data' do
      get :show, id: photo.id, user_token: @user_token, album_id: album.id
      photo = Photo.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(photo).keys)
    end
  end

  describe '#update' do
    let(:new_title) { Faker::Lorem.word }

    before(:each) do
      @photo = create(:photo, album: album)
    end

    it 'response should be success' do
      put :update, album_id: album.id, id: @photo.id, resource: { title: new_title }, user_token: @user_token
      expect(response).to be_success
    end

    it 'changes photo name' do
      put :update, album_id: album.id, id: @photo.id, resource: { title: new_title }, user_token: @user_token
      expect(@photo.reload.title).to eq new_title
    end

    it 'access denied' do
      put :update, album_id: album.id, id: @photo.id, resource: { title: new_title }
      expect(response).to be_forbidden
    end
  end

  describe '#destroy' do
    it 'returns http success' do
      delete :destroy, album_id: album.id, id: photo.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'access denied' do
      delete :destroy, album_id: album.id, id: photo.id
      expect(response).to be_forbidden
    end
  end
end
