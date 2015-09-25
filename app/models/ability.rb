class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :show, User

    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :update, User, id: user.id
      can :manage, Album, user_id: user.id
    end
  end
end
