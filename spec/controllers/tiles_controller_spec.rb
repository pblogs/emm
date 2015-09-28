require 'rails_helper'

RSpec.describe TilesController, type: :controller do

  describe '#index' do
    let(:user) { create(:user) }
    let!(:photo) { create_list(:photo, 4, album: user.default_album) }

    it 'responds with success' do
      get :index, user_id: user.id
      expect(response).to be_success
    end

    it 'returns correct tiles count' do
      get :index, user_id: user.id
      expect(json_response['meta']['total']).to eq user.tiles.count
    end
  end

  describe '#update' do
    login_user
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
end
