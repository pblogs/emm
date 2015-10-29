require 'rails_helper'

RSpec.describe Album, type: :model do

  let(:user) { create(:user) }

  describe 'default album' do
    it 'should be auto created with user' do
      expect(user.albums.first.default?).to be_truthy
    end

    it 'should be only 1 per user' do
      expect(user.albums.build(default: true)).to be_invalid
    end

    it 'should not be destroyable' do
      expect(user.default_album.destroy).to be_falsey
    end

    it 'should be destroyed when user is destroying' do
      user.reload
      expect { user.destroy }.to change { user.albums.count }.by(-1)
    end
  end

  describe 'tiles' do
    it 'should be created a tile on user page when new album is created' do
      user.reload
      expect { create(:album, user: user) }.to change { user.tiles.count }.by(1)
    end

    it 'should not be created a tile on user page for default album' do
      expect(user.default_album.tile).to be_nil
    end
  end

  describe 'cached columns' do
    let(:album) { create(:album, user: user) }
    %i{ photo video text }.each do |content|
      it 'should update count column' do
        expect { create(content, album: album) }.to change { album.send("#{content}s_count") }.by(1)
      end
    end
  end

  describe 'by_privacy scope' do
    let!(:album_for_friends) { create(:album, user: user, privacy: :for_friends) }
    let!(:album_for_all) { create(:album, user: user, privacy: :for_all) }

    context 'privacy for_friends' do
      it 'should return correct albums' do
        expect(user.albums.by_privacy(:for_friends).pluck(:id)).to be_eql [user.default_album.id, album_for_friends.id, album_for_all.id]
      end
    end

    context 'privacy for_all' do
      it 'should return correct albums' do
        expect(user.albums.by_privacy(:for_all).pluck(:id)).to be_eql [user.default_album.id, album_for_all.id]
      end
    end
  end
end
