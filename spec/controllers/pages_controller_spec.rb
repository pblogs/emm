require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  login_user

  describe '#index' do
    it 'responds with success' do
      get :index, user_id: @user.id
      expect(response).to be_success
    end

    it 'returns correct pages count' do
      get :index, user_id: @user.id
      expect(json_response['meta']['total']).to eq @user.pages.count
    end
  end

  describe '#show' do
    let!(:like) do
      photo = create(:photo, user: @user)
      photo.create_tile_on_user_page
      photo.likes.create(user: @user)
    end

    subject do
      get :show, user_id: @user.id, id: @user.pages.last.id
    end

    it 'should response success' do
      subject
      expect(response).to be_success
    end

    it 'should respond with content data' do
      subject
      expect(json_response['resource'].keys).to contain_exactly(*serialized(@user.pages.first, nil, nil, with_tiles: true).keys)
    end

    it 'should have like on show' do
      get :show, user_id: @user.id, id: @user.pages.first.id, user_token: @user_token
      expect(json_response['resource']['tiles'].map { |tile| tile['content'].try(:[], 'like')}.compact.count).to eq(@user.likes.count)
    end
  end

  describe '#update_tiles' do
    let!(:page) { @user.pages.create }
    let!(:tiles) do
      # Generating some tiles
      create_list(:text, 3, album: @user.default_album)
      Tile.unscoped.where(page_id: page.id).order(:id).pluck(:id).map do |tile_id|
        {
            id: tile_id,
            size: Tile.sizes.keys.sample,
            col: rand(5),
            row: rand(5)
        }
      end
    end

    subject do
      put :update_tiles, user_id: @user.id, page_id: page.id, resource: {tiles: tiles}, screen_size: 'md', user_token: @user_token
    end

    it 'should response success' do
      subject
      expect(response).to be_success
    end

    it 'should update tiles' do
      subject
      requested_tile_positions = tiles.map { |t| [t[:id], t[:size], t[:col], t[:row]] }
      actual_tile_positions = Tile.unscoped.where(page_id: page.id).order(:id).map { |t| [t.id, t.size, t.col, t.row] }
      expect(actual_tile_positions).to be_eql requested_tile_positions
    end

    it 'should respond with page data' do
      subject
      expect(json_response['resource'].keys).to contain_exactly(*serialized(page, nil, nil, with_tiles: true).keys)
    end

    context 'other user' do
      let(:other_user) { create(:user, :confirmed) }

      it 'responds unauthorized' do
        put :update_tiles, user_id: @user.id, page_id: page.id, resource: {tiles: tiles}, screen_size: 'md', user_token: other_user.jwt_token
        expect(response).to be_forbidden
      end
    end
  end
end
