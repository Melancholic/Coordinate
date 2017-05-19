class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ExceptionLogger::ExceptionLoggable # loades the module
  rescue_from Exception, :with => :log_exception_handler # tells rails to forward the 'Exception' (you can change the type) to the handler of the module
  include SessionsHelper
  include ApplicationHelper


  def authenticate_admin_user!
    unless current_admin_user
      flash[:error] = t('modals.access_error')
      redirect_to root_path
    end
  end

  def current_admin_user
    #signed_in?
    return nil if signed_in? && !current_user.admin?
    current_user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def not_found
    raise ActionController::RoutingError.new('Resource not found!')
  end

  def do_agreed
    respond_to do |format|
      format.html {redirect_to agreement_path}
      format.json {render status: :bad_request, :json => {:success => false, :info => "You must agree to all the terms and conditions of the user agreement."}}
      format.js {redirect_to agreement_path}
    end
  end
end
