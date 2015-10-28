class Like < ActiveRecord::Base
  TARGETS = %w(comment video text photo tribute album)

  validates :user, uniqueness: { scope: [:target_id, :target_type],
                                 message: I18n.t('activerecord.errors.models.like.already_liked') }

  belongs_to :user, inverse_of: :likes
  belongs_to :target, polymorphic: true, inverse_of: :likes, counter_cache: true
end
