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
end