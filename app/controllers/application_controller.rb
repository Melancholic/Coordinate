class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper
  def authenticate_admin_user!
    unless current_admin_user
      flash[:error] = "Access error!"
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
end
