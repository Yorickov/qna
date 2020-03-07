class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id

    can :vote_up, [Question, Answer] do |item|
      !user.author_of?(item)
    end

    can :vote_down, [Question, Answer] do |item|
      !user.author_of?(item)
    end

    can :vote_reset, [Question, Answer] do |item|
      !user.author_of?(item)
    end

    can :choose_best, Answer do |answer|
      user.author_of?(answer.question)
    end
  end
end
