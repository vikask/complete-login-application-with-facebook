class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end



  def authenticate_admin_user!
    authenticate_user!
    unless currnet_user.admin?
      flash[:alert] = "This area is restricted to administrator only."
      redirect_to root_url
    end
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
