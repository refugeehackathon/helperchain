class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Project if user.nil?
    can :charities, Project
    can :create, Helper
    can :unsubscribe, Helper
    can :confirm, Helper

    if not user.nil?
      # Project
      can :show, Project, id: user.project_id
      # Requests
      can :create, Request
      can :show, Request, project: user.project
      can :manage, Request, manager_in_charge_id: user.id
      # Manager
      can [:edit, :update], Manager, id: user.id
      can :show, Manager, project: user.project
      # Helper
      can [:subscribe_many,
           :subscribe_many_post,
           :unsubscribe_many,
           :unsubscribe_many_post], Helper, project: user.project
      # Admin stuff
      if user.is_admin
        can :manage, Project, id: user.project_id
        can :manage, Helper, project: user.project
        can :manage, Manager, project: user.project
      end
    end
  end
end
