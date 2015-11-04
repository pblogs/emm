class Comment < ActiveRecord::Base

  include Likes

  # Relations
  belongs_to :author, inverse_of: :comments, class_name: User
  belongs_to :commentable, polymorphic: true # Album | Photo | Video | Text | Tribute | Relationship

  # Validations
  validates :author, :commentable, :text, presence: true
  validates  :text,  length: {maximum: 100}
end
