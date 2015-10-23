class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index, :show], User
    can [:index, :show], Page
    can [:index], Album
    can [:show], Album do |album|
      album.for_all?
    end
    can [:index], Record
    can [:show, :index], Comment

    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :update, User, id: user.id
      can :manage, Page, user_id: user.id
      can [:show, :create, :update, :destroy, :update_meta_info], [Photo, Text, Video] do |content|
        content.album.user_id == user.id
      end
      can :upload, Video
      can [:show], Album do |album|
        album.for_all? || (album.for_friends? && album.user.is_friend?(user.id))
      end
      can :manage, Album, user_id: user.id
      can [:create, :index], Relationship
      can :update, Relationship, friend_id: user.id
      can :destroy, Relationship do |relation|
        (relation.user_id == user.id || relation.friend_id == user.id) && relation.confirmed?
      end
      can :update, Record do |record|
        record.album.user_id == user.id
      end
      can [:update, :create, :destroy], Tile do |tile|
        tile.page.user_id == user.id
      end
      can [:index, :show], Tribute, user_id: user.id
      can :create, Tribute, author_id: user.id
      can [:update], Comment, author_id: user.id
      can [:destroy], Comment do |comment|
        comment.commentable.user.id == user.id || comment.author_id == user.id
      end
      can [:create], Comment
    end
  end
end
