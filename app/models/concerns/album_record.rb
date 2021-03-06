module AlbumRecord
  extend ActiveSupport::Concern
  include SanitizeDescription
  include Likes
  include Taggable

  included do
    # Relations
    belongs_to :album, inverse_of: name.downcase.pluralize, counter_cache: true
    has_one :record, as: :content, dependent: :destroy
    has_one :tile, as: :content, dependent: :destroy
    has_many :comments, as: :commentable, dependent: :destroy
    has_one :user, through: :album

    # Callbacks
    after_create :create_record_for_album
    after_create :create_tile_on_user_page, if: 'album.default?'
    after_save :refresh_user_content_counter
  end

  def create_tile_on_user_page(page=nil)
    page = page || self.album.user.pages.last
    self.create_tile(page: page)
  end

  private

  def create_record_for_album
    self.create_record(album: self.album)
  end

  def refresh_user_content_counter
    user.refresh_content_counter(self.class.name.tableize)
  end
end
