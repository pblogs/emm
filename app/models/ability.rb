class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:index, :show], User

    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :update, User, id: user.id
      can [:show, :create, :update, :destroy], [Photo, Text, Video] do |content|
        content.album.user_id == user.id
      end
      can :manage, Album, user_id: user.id
      can [:index, :update], Record do |record|
        record.album.user_id == user.id
      end
    end
  end
end
