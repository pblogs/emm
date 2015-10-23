module Likes
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :target, inverse_of: :target, dependent: :delete_all
  end
end
