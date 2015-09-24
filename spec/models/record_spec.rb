require 'rails_helper'

RSpec.describe Record, type: :model do

  let(:album) { create(:album) }
  let(:another_album) { create(:album) }

  describe 'ordering' do

    before :each do
      # Creating records for other album (just to add some other data)
      2.times { create(:text, album: another_album) }
      # Creating records for tested album
      3.times { create(:text, album: album) }
    end

    it 'should be created with incremented weight (within album)' do
      last_record_weight = album.records.last.weight
      expect(create(:text, album: album).record.weight).to be_eql last_record_weight+1
    end

    it 'should be created with incremented weight (within album)' do
      expect(album.records.map(&:weight)).to be_eql [0, 1, 2]
    end
  end
end
