class Comment < ActiveRecord::Base

  # Relations
  belongs_to :author, inverse_of: :comments, class_name: User
  belongs_to :commentable, polymorphic: true # Album | Photo | Video | Text | Tribute

  # Validations
  validates :author, :commentable, :text, presence: true
end
