require 'rails_helper'

RSpec.describe NewsFeedsController, type: :controller do
  login_user

  let(:per_page) { 3 }
  let(:types) { %W{photo video text } }
  let!(:news) do
    types.each do |type|
      user = create(:user, :confirmed)
      album = create(:album, user: user)
      rel = create(:relationship, sender: @user, recipient: user)
      rel.update(status: 'accepted')
      content = create(type, album: album)
      content.create_tile_on_user_page
      create(:like, target: content, user: @user)
    end
  end

  describe '#index' do
    it 'should response success' do
      get :index, user_token: @user_token
      expect(response).to be_success
    end

    it 'returns correct per page' do
      get :index, user_token: @user_token, per_page: per_page
      expect(json_response['resources'].length).to eq per_page
    end

    it 'should return only one notification when two your friends become friends' do
      #add friend
      friend = create(:user, :confirmed)
      create(:relationship, sender: friend, recipient: @user, status: 'accepted')

      #add relationship between your friends
      rel = create(:relationship, sender: friend, recipient: @user.friends.first)
      rel.update_attribute(:status, 'accepted')

      get :index, user_token: @user_token
      expect(json_response['resources'].map{|tile| tile['id']}).to_not include(Tile.unscoped.where(content:rel).first.id)
    end

    it 'returns all tile types' do
      get :index, user_token: @user_token
      expect(json_response['meta']['total']).to eq(9) # 3 contents, 3 albums, 3 relationships
    end

    it 'should have like' do
      get :index, user_token: @user_token
      expect(json_response['resources'].map { |tile| tile['content']['like']}.compact.count).to eq(@user.likes.count)
    end

    it 'should access denied' do
      get :index
      expect(response).to be_forbidden
    end
  end
end
