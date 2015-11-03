module UserRelations
  extend ActiveSupport::Concern

  included do
    # Relations
    has_many :incoming_relationships, foreign_key: :recipient_id, class_name: 'Relationship', dependent: :destroy
    has_many :outgoing_relationships, foreign_key: :sender_id, class_name: 'Relationship', dependent: :destroy
  end

  def relationships
    Relationship.where('sender_id = :user_id OR recipient_id = :user_id', user_id: self.id)
  end

  # Methods
  def relation_to(user_id)
    Relationship.find_by(sender_id: [self.id, user_id], recipient_id: [self.id, user_id])
  end

  def is_friend?(user_id)
    ids = [id, user_id]
    Relationship.where(sender_id: ids, recipient_id: ids, status: Relationship.statuses['accepted']).exists?
  end

  def incoming_friends
    User.joins('INNER JOIN relationships ON sender_id = users.id')
        .select('users.*, relationships.id AS relationship_id')
        .where('relationships.recipient_id = ?', self.id)
        .where('relationships.status = ?', Relationship.statuses[:pending])
  end

  def outgoing_friends
    User.joins('INNER JOIN relationships ON recipient_id = users.id')
        .select('users.*, relationships.id AS relationship_id')
        .where('relationships.sender_id = ?', self.id)
        .where('relationships.status = ?', Relationship.statuses[:pending])
  end

  def friends
    User.joins('INNER JOIN relationships ON sender_id = users.id OR recipient_id = users.id')
        .select('users.*, relationships.id AS relationship_id')
        .where('sender_id = :user_id OR recipient_id = :user_id', user_id: self.id)
        .where.not('users.id' => self.id)
        .where('relationships.status = ?', Relationship.statuses[:accepted])
  end

  def related_users
    User.joins('LEFT JOIN relationships AS rel ON rel.sender_id = users.id OR rel.recipient_id = users.id')
        .select('users.*, rel.id AS relationship_id')
        .where.not('users.id' => self.id)
        .where('rel.sender_id = :user_id OR rel.recipient_id = :user_id', user_id: self.id)
        .where('rel.status IN (0, 1)')
        .order("CASE WHEN(rel.status = 0 AND rel.recipient_id = #{self.id}) THEN 0 WHEN(rel.status = 1) THEN 1 WHEN(rel.status = 0) THEN 2 ELSE 3 END")
        .order('rel.updated_at DESC')
  end
end
