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
      if current_user
        redirect_to contacts_url 
      else
        redirect_to login_path
      end
      return false
    end
  end

  def require_admin_or_visitor_account
    unless current_user.nil? || current_user.admin?
      flash[:error] = "You are not allowed to see this page"
      redirect_to contacts_url
      return false
    end
  end

  def store_location
    #session[:return_to] = request.request_uri
    session[:return_to] = request.fullpath
  end

  def admin_agent_redirect_path
    if current_user and current_user.admin?
      agents_path   
    elsif current_user 
      contacts_path   
    else
      login_path   
      #if not logged in then
    end
  end
end
