class Video < ActiveRecord::Base

  include AlbumRecord

  # Relations
  belongs_to :album, inverse_of: :videos
  has_one :record, as: :content, dependent: :destroy
  has_one :tile, as: :content, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # Validations
  validates :album, :video_id, :preview, presence: true

  # Uploaders
  mount_uploader :preview, PhotoUploader
end
