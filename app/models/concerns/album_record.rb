module AlbumRecord
  extend ActiveSupport::Concern

  included do
    # Callbacks
    after_create :create_record_for_album, :create_tile_on_user_page
  end

  private

  def create_record_for_album
    self.create_record(album: self.album)
  end

  def create_tile_on_user_page
    self.create_tile(user: self.album.user) if self.album.default?
  end
end
