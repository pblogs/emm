require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  login_user

  let(:target) { create(%i{ photo video text album tribute}.sample) }
  let(:author) { create(:user, :confirmed) }
  let!(:comment) { create_list(:comment, 2, commentable: target, author: author).first }
  let(:another_user) { create(:user, :confirmed) }


  describe '#index' do
    it 'should response success' do
      get :index, target_id: target.id, target_type: target.class.name.underscore, user_token: @user_token
      expect(response).to be_success
    end

    it 'should return correct comments count' do
      get :index, target_id: target.id, target_type: target.class.name.underscore, user_token: @user_token
      expect(json_response['meta']['total']).to eq target.comments.count
    end
  end

  describe '#show' do
    it 'should response success' do
      get :show, target_id: target.id, target_type: target.class.name.underscore, id: comment.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'should respond with comment data' do
      get :show, target_id: target.id, target_type: target.class.name.underscore, id: comment.id, user_token: @user_token
      comment = Comment.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(comment).keys)
    end

    # TODO Turn it back when back-end will be fixed to prevent showing comments for private content
    # it 'access denied' do
    #   get :show, target_id: target.id, target_type: target.class.name.underscore, id: comment.id
    #   expect(response).to be_forbidden
    # end
  end

  describe '#create' do
    let(:create_attributes) { attributes_for(:comment) }

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
  end

  describe '#update' do
    let(:new_text) { Faker::Lorem.characters(char_count = 100) }

    before(:each) do
      @comment = create(:comment, commentable: target, author: author)
    end

    it 'response should be success' do
      put :update, id: comment.id, target_id: target.id, target_type: target.class.name.underscore, user_token: author.jwt_token,
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
