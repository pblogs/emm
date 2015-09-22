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
end
