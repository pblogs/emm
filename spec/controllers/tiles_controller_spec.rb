require 'rails_helper'

RSpec.describe TilesController, type: :controller do
  login_user

  let(:page) { @user.default_page }
  let!(:text) { create(:text, album: @user.default_album) }
  let(:tile) { text.tile }

  %W(album tribute video photo text).each do |content_type|
    describe '#create' do
      let(:content) { create(content_type, user: @user) }

      context 'owner user' do
        subject do
          post :create, target_id: content.id, target_type: content_type, user_token: @user_token, resource: {size: 'small'}
        end

        it 'should response success' do
          subject
          expect(response).to be_success
        end

        it 'should create new tile' do
          expect { subject }.to change(@user.tiles, :count).by 1
        end

        it 'should respond with tile data' do
          subject
          expect(json_response['resource'].keys).to contain_exactly(*serialized(content.reload.tile).keys)
        end
      end

      context 'other user' do
        let(:other_user) { create(:user) }

        it 'responds unauthorized' do
          post :create, target_id: content.id, target_type: content_type, resource: {size: 'small'}, user_token: other_user.jwt_token
          expect(response).to be_unauthorized
        end
      end

      context 'guest user' do
        it 'responds access denied' do
          post :create, target_id: content.id, target_type: content_type, resource: {size: 'small'}
          expect(response).to be_forbidden
        end
      end
    end
  end

  describe '#update' do
    context 'owner user' do
      subject do
        put :update, page_id: page.id, id: tile.id, resource: {size: 'large'}, user_token: @user_token
      end

      it 'responds success' do
        subject
        expect(response).to be_success
      end

      it 'changes tile weight' do
        subject
        expect(tile.reload.size).to eq 'large'
      end
    end

    context 'other user' do
      let(:other_user) { create(:user) }

      it 'responds unauthorized' do
        put :update, page_id: page.id, id: tile.id, resource: {size: 'large'}, user_token: other_user.jwt_token
        expect(response).to be_unauthorized
      end
    end

    context 'guest user' do
      it 'responds access denied' do
        put :update, page_id: page.id, id: tile.id, resource: {size: 'large'}
        expect(response).to be_forbidden
      end
    end
  end

  describe '#destroy' do
    context 'owner user' do
      it 'responds success' do
        delete :destroy, page_id: page.id, id: tile.id, user_token: @user.jwt_token
        expect(response).to be_success
      end
    end

    context 'other user' do
      let(:other_user) { create(:user) }

      it 'responds unauthorized' do
        delete :destroy, page_id: page.id, id: tile.id, user_token: other_user.jwt_token
        expect(response).to be_unauthorized
      end
    end

    context 'guest user' do
      it 'responds access denied' do
        delete :destroy, page_id: page.id, id: tile.id
        expect(response).to be_forbidden
      end
    end
  end
end
