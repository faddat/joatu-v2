class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_filter :configure_permitted_parameters, if: :devise_controller?

  after_action :set_csrf_cookie, if: -> { protect_against_forgery? }
  after_action :verify_authorized, :except => :index, unless: -> { is_a?(DeviseController) || is_a?(ActiveAdmin::BaseController) }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Default locale to be included with each request:
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  private

  # We're using a separate Authentication object to handle retrieving the current user,
  # determining who (if anyone) is signed in, etc. Because many rails systems
  # that interface with devise expect a current_user and user_signed_in? helper
  # at the controller level, we're including them here and having them call out
  # to this custom object.
  def authentication
    Authentication.instance_or_build do |config|
      config.warden = request.env["warden"]
    end
  end

  def current_user
    authentication.user
  end

  def user_signed_in?
    authentication.user_signed_in?
  end

  # Devise invitable gem uses this method to determine whether someone can
  # send invitations. Here we're just having it redirect to pundit, so that
  # all our authorization is in one place.
  def authenticate_inviter!
    authenticate_user!
    raise Pundit::NotAuthorizedError unless Pundit.policy!(current_user, :invitation).send?
  end

  def user_not_authorized
    flash[:alert] = t('flash.not_authorized')
    redirect_to(request.referrer || root_path)
  end

  def set_locale
    current_user.preferences.locale = params[:locale]
    current_user.save! # Save any changes. Will no-op if nothing changed.
    I18n.locale = current_user.preferences.locale.to_sym
  end

  def set_csrf_cookie
    # Transmit CSRF token via cookie to fascilitate caching: 
    cookies[:csrftoken] = {
      value: form_authenticity_token,
      expires: 1.day.from_now,
    }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat [:tou_agreement]
  end

  def guest_instance
    @guest_instance ||= GuestUser.new
  end
end
