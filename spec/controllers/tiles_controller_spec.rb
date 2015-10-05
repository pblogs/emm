require 'rails_helper'

RSpec.describe TilesController, type: :controller do
  login_user

  let(:user) { create(:user, :confirmed) }
  let!(:photo) { create_list(:photo, 4, album: user.default_album).first }

  describe '#index' do
    it 'responds with success' do
      get :index, user_id: user.id
      expect(response).to be_success
    end

    it 'returns correct tiles count' do
      get :index, user_id: user.id
      expect(json_response['meta']['total']).to eq user.tiles.count
    end
  end

  describe '#create' do
    %W(album tribute video photo text).each do |content|
      let(:content_class) { content.camelize.constantize }
      let(:content_object) { create(content) }

      subject do
        post :create, target_id: content_object.id, target_type: content_object.class.name.underscore, user_token: @user_token,
             resource: { size: 'small'}
      end

      it 'should response success' do
        subject
        expect(response).to be_success
      end

      it 'should respond with content data' do
        subject
        found_content = content_class.find(json_response['resource']['id'])
        expect(json_response['resource'].keys).to contain_exactly(*serialized(found_content).keys)
      end

      it 'access denied' do
        post :create, target_id: content_object.id, target_type: content_object.class.name.underscore, resource: { size: 'small'}
        expect(response).to be_forbidden
      end
    end
  end

  describe '#update' do
    let!(:photo) { create(:photo, album: @user.default_album) }

    describe 'valid user' do
      subject do
        put :update, user_id: @user.id, id: photo.tile.id, resource: { size: 'large' }, user_token: @user_token
      end

      it 'responds with success' do
        subject
        expect(response).to be_success
      end

      it 'changes tile weight' do
        subject
        expect(photo.reload.tile.size).to eq 'large'
      end
    end

    describe 'invalid user' do
      it 'responds unauthorized for other users' do
        other_user = create(:user)
        put :update, user_id: @user.id, id: photo.tile.id, resource: { size: 'large' }, user_token: other_user.jwt_token
        expect(response).to be_unauthorized
      end

      it 'responds forbidden for unauthenticated  users' do
        put :update, user_id: @user.id, id: photo.tile.id, resource: { size: 'large' }
        expect(response).to be_forbidden
      end
    end
  end

  describe '#destroy' do
    it 'returns http success' do
      delete :destroy, user_id: user.id, id: photo.tile.id, user_token: user.jwt_token
      expect(response).to be_success
    end

    it 'access denied' do
      delete :destroy, user_id: user.id, id: photo.tile.id
      expect(response).to be_forbidden
    end
  end
end
