module Taggable
  extend ActiveSupport::Concern

  included do
    # Relations
    has_many :tags, as: :target, inverse_of: :target, dependent: :delete_all

    accepts_nested_attributes_for :tags, allow_destroy: true
  end

  def replace_tags_attributes=(args)
    self.tags.map(&:mark_for_destruction)
    self.tags_attributes = args
  end
end
