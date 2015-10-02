module AlbumRecord
  extend ActiveSupport::Concern

  included do
    # Relations
    belongs_to :album, inverse_of: name.downcase.pluralize, :counter_cache => true
    has_one :record, as: :content, dependent: :destroy
    has_one :tile, as: :content, dependent: :destroy
    has_many :comments, as: :commentable, dependent: :destroy

    has_one :user, through: :album

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
