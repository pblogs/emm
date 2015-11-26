require 'rails_helper'

RSpec.describe StorageRecordsController, type: :controller do
  login_user

  let(:types) { %W{photo video text album} }
  let!(:tiles_in_storage) do
    types.each do |type|
      content = create(type)
      content.create_tile_on_user_page.move_to_storage
      @user.storage.tiles
    end
  end
  let(:tile) { create(:album, user: @user).create_tile_on_user_page }

  describe '#index' do
    it 'should response success' do
      get :index, user_token: @user_token
      expect(response).to be_success
    end

    it 'returns correct tiles count' do
      get :index, user_token: @user_token
      expect(json_response['resources'].length).to eq @user.storage.tiles.count
    end
  end

  describe '#create' do
    it 'should response success' do
      post :create, user_token: @user_token, tile_id: tile
      expect(response).to be_success
    end

    it 'should move tile to storage' do
      expect {
        post :create, user_token: @user_token, tile_id: tile
      }.to change(@user.storage.tiles, :count).by 1
    end
  end
end
