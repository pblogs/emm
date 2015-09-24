class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    #todo admin
    if user.persisted?
      can :update, User, id: user.id
      can :show, User
    end
  end
end
