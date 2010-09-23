class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :current_user_session

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = Session.find
  end

  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record 
  end


  def require_valid_account
    unless current_user
      store_location
      flash[:error] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_admin_account
    unless current_user && current_user.admin?
      flash[:error] = "You are not allowed to see this page"
      #change this to warning
      redirect_to contact_lists_url
      return false
    end
  end

  def store_location
    #session[:return_to] = request.request_uri
    session[:return_to] = request.fullpath
  end
end
