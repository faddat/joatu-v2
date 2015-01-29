class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :verify_authorized, :except => :index, unless: -> { is_a? DeviseController }

  def authenticated_user
    @authenticated_user ||= UserRepo.find(current_user.id)
  end

  def pundit_user
    authenticated_user
  end


  protected
  
  # Devise invitable gem uses this method to determine whether someone can
  # send invitations. Here we're just having it redirect to pundit, so that
  # all our authorization is in one place.
  def authenticate_inviter!
    authenticate_user!
    raise Pundit::NotAuthorizedError unless Pundit.policy!(current_user, :invitation).send?
  end

  # Defined to make current_user a protected method. Use
  # authenticated_user instead, which returns the domain object!
  def current_user
    super
  end
end
