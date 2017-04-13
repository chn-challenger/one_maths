class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :create, :read, :update, :delete, to: :crud
    alias_action :read, :update, to: :basic_crud
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.has_role? :super_admin
        can :manage, :all
      elsif user.has_role? :admin
        can :manage, :all
      elsif user.has_role? :question_writer
        can :read, Unit, job: { worker_id: user.id }
        can :read, Job
        can [:update, :read], Question, job: { worker_id: user.id }
        can :crud, [Answer, Choice], question: { job: { worker_id: user.id } }
      elsif user.has_role? :tester
        can :read, Unit
        can :create, AnsweredQuestion
        can [:delete, :read, :update], AnsweredQuestion, user_id: user.id
        can :basic_crud, Question
        can :crud, [Answer, Choice]
        can :create, Ticket
        can :read, Ticket, owner_id: user.id
      elsif user.has_role? :student
        can :read, Course, Course.all do |course|

        end
        can :create, AnsweredQuestion
        can :read, Unit, job: nil
        can :create, Ticket
        can :read, Ticket, owner_id: user.id
      elsif user.has_role? :teacher
        can :create, Course
        can [:update, :delete], Course, owner_id: user.id
        can :read, Unit, job: nil
        can :create, Unit, course: { owner_id: user.id }
        can [:update, :delete], Unit, course: { owner_id: user.id }
        can [:read, :create], Topic
        can [:update, :delete], Topic, unit: { course: { owner_id: user.id } }
        can [:read, :create], Lesson
        can [:update, :delete], Lesson, topic: { unit: { course: { owner_id: user.id } } }
        can [:read, :create], Question
        can [:update, :delete], Question, creator_id: user.id
        can :create, [Answer, Choice]
        can [:update, :delete], Answer, question: { creator_id: user.id }
        can [:update, :delete], Choice, question: { creator_id: user.id }
        can :crud, AnsweredQuestion
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
