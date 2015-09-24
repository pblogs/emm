module AlbumRecord
  extend ActiveSupport::Concern

  included do
    # Callbacks
    after_create :create_record_for_album
    after_create :create_tile_on_user_page, if: 'album.default?'
  end

  def create_tile_on_user_page(size=:small)
    self.create_tile(user: self.album.user, size: size)
  end

  private

  def create_record_for_album
    self.create_record(album: self.album)
  end
end
