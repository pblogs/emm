require 'rails_helper'

RSpec.describe Tile, type: :model do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'ordering' do

    before :each do
      # Creating tiles for other user (just to add some other data)
      2.times { create(:text, album: another_user.default_album) }
      create :album, user: another_user
      # Creating tiles for tested user
      3.times { create(:text, album: user.default_album) }
      create :album, user: user
    end

    it 'should be created with incremented weight (within user)' do
      top_tile_weight = user.tiles.first.weight
      expect(create(:text, album: user.default_album).tile.weight).to be_eql top_tile_weight+1
    end

    it 'should be ordered from top weight to last' do
      expect(user.tiles.pluck(:weight)).to be_eql [3, 2, 1, 0]
    end
  end
end
