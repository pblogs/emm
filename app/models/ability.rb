class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index, :show], User
    can [:index, :show], Album
    can [:index], Tile
    can [:index], Record

    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :update, User, id: user.id
      can [:show, :create, :update, :destroy], [Photo, Text, Video] do |content|
        content.album.user_id == user.id
      end
      can :manage, Album, user_id: user.id
      can :update, Record do |record|
        record.album.user_id == user.id
      end
      can :update, Tile, user_id: user.id
      can [:index, :show], Tribute, user_id: user.id
      can :create, Tribute, author_id: user.id
      can [:update], Comment, author_id: user.id
      can [:destroy], Comment do |comment|
        comment.commentable.user_id == user.id || comment.author_id == user.id
      end
      can [:create, :show, :index], Comment
    end
  end
end
