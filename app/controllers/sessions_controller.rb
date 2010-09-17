class SessionsController < ApplicationController

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(params[:session])
    if @session.save
      flash[:notice] = "Successfully logged in"

      redirect_to contact_lists_path
    else
      flash.now[:error] = "There was an error while trying to log you in"
      render :action => 'new'
    end
  end

  def destroy
    @session = Session.find
    @session.destroy
    flash[:notice] = "Successfully logged off"
    redirect_to login_url
  end

end
