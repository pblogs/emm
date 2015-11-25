class Admin < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable

  self.table_name = 'users'
  default_scope { where(role: User.roles[:admin]) }
end
