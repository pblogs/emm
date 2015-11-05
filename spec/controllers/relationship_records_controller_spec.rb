require 'rails_helper'

RSpec.describe RelationshipRecordsController, type: :controller do
  login_user
  let!(:album) { create(:album_with_tags, user: @user) }
  let!(:relationship_id) { album.user.friends.last.relationship_id }

  describe '#index' do
    subject { get :index, relationship_id: relationship_id, user_token: @user_token }
    it 'should response success' do
      subject
      expect(response).to be_success
    end

    it 'should response success for stranger' do
      get :index, relationship_id: relationship_id
      expect(response).to be_success
    end

    it 'should respond with right records' do
      subject
      expect(json_response['resources'].map { |tag| tag['target']['id']}.compact.sort)
        .to eq(album.user.friends.last.tags.map(&:target_id).sort)
    end

    it 'should respond with tag data' do
      subject
      tag = Tag.find(json_response['resources'].first['id'])
      expect(json_response['resources'].first.keys).to contain_exactly(*serialized(tag, TagContentSerializer).keys)
    end

    it 'should have likes' do
      album.records.last.content.likes.create(user: @user)
      subject
      expect(json_response['resources'].map { |tag| tag['target']['like']}.compact.count).to eq(@user.likes.count)
    end

    it 'should not response private records for another user' do
      album = create(:album_with_tags, user: @user, privacy: :for_friends)
      relationship_id = album.user.friends.last.relationship_id
      another_user = create(:user, :confirmed)

      #except album, because it has tile
      excluded_ids = album.records.map { |record| record.content_id }

      get :index, relationship_id: relationship_id, user_token: another_user.jwt_token
      expect(json_response['resources'].map { |tag| tag['target']['id']}).not_to include(*excluded_ids)
    end
  end

  describe '#create' do
    subject { post :create, relationship_id: relationship_id, tag_id: tag.id, user_token: tag.user.jwt_token }

    let(:tag) { album.records.first.content.tags.first }
    it 'should response success' do
      post :create, relationship_id: relationship_id, tag_id: tag.id, user_token: @user_token
      expect(response).to be_success
    end

    it 'should duplicate record' do
      expect {
        subject
      }.to change(tag.target.class.where(original_id: tag.target.id), :count).by 1
    end

    it 'should create tile for duplicated record' do
      expect {
        subject
      }.to change(Tile, :count).by 1
    end

    it 'should create tile for previously duplicated record' do
      copy = create(tag.target.class.name.downcase, original_id: tag.target.id, album: tag.user.default_album)
      subject
      expect(json_response['resource']['id']).to eq(copy.tile.id)
    end

    it 'should respond with tile data' do
      subject
      tile = Tile.find(json_response['resource']['id'])
      expect(json_response['resource'].keys).to contain_exactly(*serialized(tile).keys)
    end

    it 'should not process wight Album' do
      expect {
        post :create, relationship_id: relationship_id, tag_id: album.tags.first, user_token: tag.user.jwt_token
      }.to raise_error(ParamError::NotAcceptableValue)
    end

    it 'access denied' do
      post :create, relationship_id: relationship_id, tag_id: tag.id, user_token: create(:user, :confirmed).jwt_token
      expect(response).to be_forbidden
    end
  end
end
