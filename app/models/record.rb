class Record < ActiveRecord::Base

  # Relations
  belongs_to :album, inverse_of: :records
  belongs_to :content, polymorphic: true # Photo | Video | Text

  # Validations
  validates :album, :content, :weight, presence: true

  # Scopes
  default_scope { order(weight: :asc).order(created_at: :asc) }  # Tiles with lower weight (and the oldest) appears first

  # Callbacks
  before_create :set_weight

  private

  def set_weight
    top_record = self.album.records.last
    self.weight = top_record.present? ? top_record.weight.next : 0
  end
end
