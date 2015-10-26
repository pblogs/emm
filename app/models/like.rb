class Like < ActiveRecord::Base
  TARGETS = %w(comment video text photo tribute)

  belongs_to :user, inverse_of: :likes
  belongs_to :target, polymorphic: true, inverse_of: :likes, counter_cache: true
end
