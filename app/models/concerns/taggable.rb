module Taggable
  extend ActiveSupport::Concern

  included do
    # Relations
    has_many :tags, as: :target, inverse_of: :target, dependent: :delete_all

    accepts_nested_attributes_for :tags, allow_destroy: true
  end

  def replace_tags_attributes=(tags_attrs)
    if self.persisted?
      self.tags.each do |tag|
        something_was_rejected = tags_attrs.reject! { |tag_attr| tag_attr[:user_id].to_s == tag.user_id.to_s && tag_attr[:author_id].to_s == tag.author_id.to_s }
        tag.mark_for_destruction if something_was_rejected.nil?
      end
    else
      self.tags = []
    end
    self.tags_attributes = tags_attrs
  end
end
