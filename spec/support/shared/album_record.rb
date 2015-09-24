require 'rails_helper'

shared_examples_for 'album_record' do

  let(:model) { described_class } # Photo | Video | Text
  let(:media) { create(model) }

  it 'should be created new record for media when created' do
    expect(media.record).to be_persisted
  end

  it 'should create new tile for user when created in default album' do
    user = create(:user)
    expect { create(model, album: user.default_album) }.to change { user.tiles.count }.by(1)
  end

  it 'should not create new tile for user when created in regular album' do
    user = create(:user)
    album = create(:album, user: user)
    expect { create(model, album: album) }.not_to change { user.tiles.count }
  end
end
