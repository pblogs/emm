class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.persisted?
      can :update, User, id: user.id
      can :show, User
    end
  end
end
