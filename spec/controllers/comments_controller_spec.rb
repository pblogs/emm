require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  login_user

  let(:author) { create(:user, :confirmed) }
  let(:target) { create(:photo, user: author) }
  let(:another_user) { create(:user, :confirmed) }
  let!(:relation) { create(:relationship, :accepted, sender: author, recipient: @user) }
  let!(:comment) { create(:comment, commentable: target, author: author) }

  let(:private_albums) do
    [create(:album, :private), create(:album, :private)]
  end

  describe 'likes' do
    let!(:like) { comment.likes.create(user: @user) }

    it 'should have like on index' do
      get :index, target_id: target.id, target_type: target.class.name.underscore, user_token: @user_token
      expect(json_response['resources'].map { |comment| comment['like']}.compact.count).to eq(@user.likes.count)
    end
  end

  %i{ photo video text album tribute relationship }.each do |target_name|
    describe "#index comments for #{target_name}" do
      let(:target) do
        if target_name == :relationship
          obj = create(target_name, sender: author, status: 'accepted')
        else
          obj = create(target_name, user: author)
        end

        obj.create_tile_on_user_page if target_name == :tribute
        obj
      end
      let(:comment) { create(:comment, commentable: target, author: author) }

      it 'should response success' do
        get :index, target_id: target.id, target_type: target.class.name.underscore, user_token: @user_token
        expect(response).to be_success
      end

      it 'should return correct comments count' do
        get :index, target_id: target.id, target_type: target.class.name.underscore, user_token: @user_token
        expect(json_response['meta']['total']).to eq target.comments.count
      end

      it 'should not index comments to private albums' do
        album = create(:album, :private)
        private_albums.each do |album|
          get :index, target_id: album.id, target_type: album.class.name.underscore, user_token: @user_token
          expect(response).to be_forbidden
        end
      end
    end
  end

  describe '#create' do
    let(:create_attributes) { attributes_for(:comment, user: @user) }

    it 'should response success' do
      post :create, target_id: target.id, target_type: target.class.name.underscore, user_token: author.jwt_token,
           resource: create_attributes
      expect(response).to be_success
    end

    it 'should create comment' do
      expect {
        post :create, target_id: target.id, target_type: target.class.name.underscore, user_token: author.jwt_token,
             resource: create_attributes
      }.to change(Comment, :count).by 1
    end

    it 'should respond with comment data' do
      post :create, target_id: target.id, target_type: target.class.name.underscore, user_token: author.jwt_token,
           resource: create_attributes
      comment = Comment.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(comment).keys)
    end

    it 'access denied' do
      post :create, target_id: target.id, target_type: target.class.name.underscore, resource: create_attributes
      expect(response).to be_forbidden
    end

    it 'should not create comment for private album (default and for friends)' do
      private_albums.each do |album|
        post :create, target_id: album.id, target_type: album.class.name.underscore, user_token: author.jwt_token,
             resource: create_attributes
        expect(response).to be_forbidden
      end
    end
  end

  describe '#update' do
    let(:new_text) { Faker::Lorem.characters(char_count = 100) }

    before(:each) do
      @comment = create(:comment, commentable: target, author: author)
    end

    it 'response should be success' do
      put :update, id: @comment.id, target_id: target.id, target_type: target.class.name.underscore, user_token: author.jwt_token,
          resource: { text: new_text }
      expect(response).to be_success
    end

    it 'changes target name' do
      put :update, id: @comment.id, target_id: target.id, target_type: target.class.name.underscore, user_token: author.jwt_token,
          resource: { text: new_text }
      expect(@comment.reload.text).to eq new_text
    end

    it 'access denied for another user' do
      put :update, id: @comment.id, target_id: target.id, target_type: target.class.name.underscore,
          resource: { text: new_text }, user_token: another_user.jwt_token
      expect(response).to be_forbidden
    end

    it 'access denied' do
      put :update, id: @comment.id, target_id: target.id, target_type: target.class.name.underscore, resource: { text: new_text }
      expect(response).to be_forbidden
    end
  end

  describe '#destroy' do
    it 'returns http success' do
      delete :destroy, id: comment.id, target_id: target.id, target_type: target.class.name.underscore, user_token: author.jwt_token
      expect(response).to be_success
    end

    it 'access denied for another user' do
      delete :destroy, id: comment.id, target_id: target.id, target_type: target.class.name.underscore, user_token: another_user.jwt_token
      expect(response).to be_forbidden
    end

    it 'access denied' do
      delete :destroy, id: comment.id, target_id: target.id, target_type: target.class.name.underscore
      expect(response).to be_forbidden
    end
  end
end
