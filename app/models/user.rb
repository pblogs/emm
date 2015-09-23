class User < ActiveRecord::Base
  
  acts_as_jwt_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  # Relations
  has_many :albums, inverse_of: :user, dependent: :destroy
  has_many :tributes, inverse_of: :user, dependent: :destroy
  has_many :tiles, inverse_of: :user # no need to dependent destroy - tile will be destroyed by it's content
  has_many :comments, foreign_key: :author_id, dependent: :destroy
  
  # Enums
  enum role: { member: 0, admin: 1 }

  # Callbacks
  after_create :create_default_album

  # Methods
  def default_album
    self.albums.find_by_default(true)
  end

  # Uploaders
  mount_uploader :avatar, PhotoUploader

  private

  def create_default_album
    self.albums.create title: I18n.t('default_album.name'), description: I18n.t('default_album.description'), default: true
  end
end
