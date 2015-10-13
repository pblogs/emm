require 'rails_helper'

RSpec.describe Tile, type: :model do

  let(:user) { create(:user) }

  describe 'default tiles' do
    it 'should ne auto-created user (avatar and info tiles)' do
      expect(user.default_page.tiles.map(&:widget_type)).to be_eql ['avatar', 'info']
    end
  end

  describe 'choosing page to place new tile' do
    let!(:page) { user.pages.create }

    it "should be placed on last user's page" do
      new_tile = create(:text, album: user.default_album).tile
      expect(new_tile.page_id).to be_eql user.pages.last.id
    end

    it "should create new page for tile if there is no enough space on last user's page" do
      # Fill the page with tiles
      Tile::CELLS_PER_PAGE.times { create(:text, album: user.default_album).tile }
      # Creating yet another tile will add new page for itself
      expect { create(:text, album: user.default_album) }.to change { user.pages.count }.by(1)
    end
  end

  describe 'removing empty pages' do
    it "should remove page after destroying if it was last tile" do
      user.pages.create
      tile = create(:text, album: user.default_album).tile
      expect { tile.destroy }.to change { user.pages.count }.by(-1)
    end

    it "shouldn't remove default page after destroying even if it's empty" do
      expect { user.default_page.tiles.destroy_all }.not_to change { user.pages.count }
    end
  end
end
