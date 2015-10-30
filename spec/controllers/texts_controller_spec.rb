require 'rails_helper'

RSpec.describe TextsController, type: :controller do
  login_user

  let(:album) { create(:album, user: @user) }
  let(:text) { create(:text, album: album) }

  describe '#create' do
    let(:create_attributes) { attributes_for(:text) }
    let(:another_user) { create(:user) }

    it 'should response success' do
      post :create, album_id: album.id, user_token: @user_token, resource: create_attributes
      expect(response).to be_success
    end

    it 'should create text' do
      expect {
        post :create, album_id: album.id, user_token: @user_token, resource: create_attributes
      }.to change(Text, :count).by 1
    end

    it 'should respond with text data' do
      post :create, album_id: album.id, user_token: @user_token, resource: create_attributes
      text = Text.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(text).keys)
    end

    it 'should create text with tags' do
      expect {
        post :create, album_id: album.id, user_token: @user_token, resource: create_attributes.merge({tags_attributes: [{user_id: another_user.id}]})
      }.to change(Tag, :count).by 1
    end

    it 'access denied' do
      post :create, album_id: album.id, resource: create_attributes
      expect(response).to be_forbidden
    end
  end

  describe '#show' do
    it 'should response success' do
      get :show, id: text.id, user_token: @user_token, album_id: album.id
      expect(response).to be_success
    end

    it 'should respond with text data' do
      get :show, id: text.id, user_token: @user_token, album_id: album.id
      text = Text.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(text, nil, @user, with_likes: true).keys)
    end

    it 'should have like' do
      like = text.likes.create(user: @user)
      get :show, id: text.id, user_token: @user_token, album_id: album.id
      expect(json_response['resource']['like']['id']).to eq(like.id)
    end
  end

  describe '#update' do
    let(:new_title) { Faker::Lorem.word }
    let(:another_user) { create(:user) }

    before(:each) do
      @text = create(:text, :with_tags, album: album)
    end

    it 'response should be success' do
      put :update, album_id: album.id, id: @text.id, resource: { title: new_title }, user_token: @user_token
      expect(response).to be_success
    end

    it 'changes text title' do
      put :update, album_id: album.id, id: @text.id, resource: { title: new_title }, user_token: @user_token
      expect(@text.reload.title).to eq new_title
    end

    it 'should update text tags' do
      put :update, album_id: album.id, id: @text.id, user_token: @user_token, resource: ({title: new_title, replace_tags_attributes: [{user_id: another_user.id}]})
      expect(@text.reload.tags.pluck(:user_id)).to eq [another_user.id]
    end

    it 'access denied' do
      put :update, album_id: album.id, id: @text.id, resource: { title: new_title }
      expect(response).to be_forbidden
    end
  end

  describe '#destroy' do
    it 'returns http success' do
      delete :destroy, album_id: album.id, id: text.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'access denied' do
      delete :destroy, album_id: album.id, id: text.id
      expect(response).to be_forbidden
    end
  end
end
