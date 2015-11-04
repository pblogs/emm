require 'rails_helper'

RSpec.describe RelationshipRecordsController, type: :controller do
  login_user

  describe '#index' do
    let!(:album) { create(:album_with_tags, user: @user) }
    let!(:relationship_id) { album.user.friends.last.relationship_id }
    subject { get :index, relationship_id: relationship_id, user_token: @user_token }

    it 'should response success' do
      subject
      expect(response).to be_success
    end

    it 'should response success for stranger' do
      get :index, relationship_id: relationship_id
      expect(response).to be_success
    end

    it 'should respond with tagged data' do
      subject
      expect(json_response['resources'].map { |tag| tag['target']['id']}.compact.sort)
        .to eq(album.user.friends.last.tags.map(&:target_id).sort)
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
end
