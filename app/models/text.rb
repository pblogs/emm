class Text < ActiveRecord::Base

  include AlbumRecord

  # Validations
  validates :album, :title, :description, presence: true

  before_save :sanitize_description

  private

  def sanitize_description
    require 'sanitize'
    self.description = Sanitize.fragment(description, Sanitize::Config::BASIC)
  end
end
