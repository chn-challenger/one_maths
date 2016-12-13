class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :create, :read, :update, :delete, to: :crud
    alias_action :read, :update, to: :basic_crud
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.super_admin?
        can :manage, :all
      elsif user.admin?
        can :manage, :all
      elsif user.question_writer?
        can :read, Unit, job: { worker_id: user.id }
        can :read, Job
        can :update, Question, job: { worker_id: user.id }
        can :crud, [Answer, Choice], question: { job: { worker_id: user.id } }
      elsif user.tester?
        can :read, Unit
        can :crud, AnsweredQuestion, user_id: current_user.id
        can :basic_crud, Question
        can :crud, [Answer, Choice]
      elsif user.student?
        can :create, AnsweredQuestion
        can :read, Unit, job: nil
        can :create, Ticket
        can :read, Ticket, owner_id: user.id
      else
      end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
