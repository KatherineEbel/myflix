class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :require_user

  def current_user
    @current_user ||= User.find_by_id session[:current_user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def require_user
    redirect_to root_path, flash: { warning: 'You must be signed do that.' } unless logged_in?
  end
end
