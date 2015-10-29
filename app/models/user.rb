class User < ActiveRecord::Base

  include UserRelations

  acts_as_jwt_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Relations
  has_many :albums, inverse_of: :user, dependent: :destroy
  has_many :tributes, inverse_of: :user, dependent: :destroy
  has_many :pages, inverse_of: :user, dependent: :destroy
  has_many :tiles, through: :pages
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  has_many :likes, inverse_of: :user
  has_many :authored_tags, class_name: 'Tag', foreign_key: :author_id, inverse_of: :author, dependent: :destroy
  has_many :tags, inverse_of: :user, dependent: :destroy

  # Enums
  enum role: {member: 0, admin: 1}

  # Validations
  RESERVED_PAGE_ALIASES = %w[confirmation recovery users]
  validates :first_name, :last_name, :birthday, presence: true
  validates :page_alias, uniqueness: true, length: {minimum: 5}, format: {with: /\A[a-z0-9\.\-\_]*\z/, }, exclusion: {in: RESERVED_PAGE_ALIASES}, allow_blank: true

  # Callbacks
  after_create :create_default_album, :create_default_page, :create_default_tiles
  before_save :set_full_name, if: 'first_name_changed? || last_name_changed?'

  # Scopes
  scope :search_by_filter, -> (query_string) {
    if query_string.present?
      query_string = query_string.strip.gsub(/\s+/, ' ')
      where('full_name ILIKE ? OR email = ?', "%#{query_string}%", query_string).references(:tags)
    end
  }

  # Methods
  def default_album
    self.albums.find_by_default(true)
  end

  def default_page
    self.pages.find_by_default(true)
  end

  # Uploaders
  mount_base64_uploader :avatar, AvatarUploader
  mount_base64_uploader :background, BackgroundUploader

  private

  def create_default_album
    self.albums.create title: I18n.t('default_album.name'), description: I18n.t('default_album.description'), default: true, privacy: :hidden
  end

  def create_default_page
    self.pages.create default: true
  end

  def create_default_tiles
    self.default_page.tiles.create widget_type: :avatar, row: 0, col: 0, size: :large
    self.default_page.tiles.create widget_type: :info, row: 0, col: 2, size: :middle
  end

  def set_full_name
    self.full_name = "#{self.first_name} #{self.last_name}".strip.gsub(/\s+/, ' ')
  end
end
