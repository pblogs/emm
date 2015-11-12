class Notification < ActiveRecord::Base
  enum event: %i{ like comment tribute tag relationship relationship_accepted relationship_declined tribute_pin }

  scope :not_viewed, -> { where(viewed: false) }

  validates :viewed, acceptance: { accept: true }, on: :update

  belongs_to :content, polymorphic: true
  belongs_to :user

  after_save :refresh_user_unread_notifications_count

  def self.preload(items, options = {})
    items.group_by(&:content_type).each do |type, records|
      targets = records.map(&:content)
      associations = {
        Relationship: [:sender, :recipient],
        Comment: [:author],
        Tribute: [:author],
        Tag: [:author, :user],
        Tile: [:content]
      }.merge(options).fetch(type.try(:to_sym), [])

      ActiveRecord::Associations::Preloader.new.preload(targets, associations)
    end
  end

  private

  def refresh_user_unread_notifications_count
    user.refresh_unread_notifications_count
  end
end
