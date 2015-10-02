require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
  login_user

  let(:album) { create(:album, user: @user) }

  describe '#index' do
    let!(:text) { create_list(:text, 2, album: album).first }

    it 'should response success' do
      get :index, album_id: album.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'should return correct records count' do
      get :index, album_id: album.id, user_token: @user_token
      expect(json_response['meta']['total']).to eq album.records.count
    end
  end

  describe '#update' do
    let(:new_weight) { 99 }

    before(:each) do
      @photo = create(:photo, album: album)
    end

    it 'response should be success' do
      put :update, album_id: album.id, id: @photo.record.id, resource: { weight: new_weight }, user_token: @user_token
      expect(response).to be_success
    end

    it 'changes photo name' do
      put :update, album_id: album.id, id: @photo.record.id, resource: { weight: new_weight }, user_token: @user_token
      expect(@photo.reload.record.weight).to eq new_weight
    end

    it 'access denied' do
      put :update, album_id: album.id, id: @photo.record.id, resource: { weight: new_weight }
      expect(response).to be_forbidden
    end
  end
end
