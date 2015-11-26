class Storage < ActiveRecord::Base
  self.table_name = 'pages'

  validates :user, presence: true

  belongs_to :user, inverse_of: :pages
  has_many :tiles, -> { order(row: :asc).order(col: :asc).order(created_at: :asc) }, inverse_of: :page
end
