class User < ActiveRecord::Base
  acts_as_jwt_authenticatable

  enum role: { member: 0, admin: 1 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
