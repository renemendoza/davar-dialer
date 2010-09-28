class AgentsController < ApplicationController
  before_filter :require_valid_account, :except => [:new, :create, :index]
  before_filter :require_admin_or_visitor_account, :only => [:new, :create]
  before_filter :require_admin_account, :only => [:index, :approve]
  #
  def index
    @agents = Agent.agents
  end

  def new
    @agent = Agent.new
  end

  def create
    @agent = Agent.new(params[:agent])
    if @agent.save
      #Session.create(@agent)  ##disabled, we no longer do autologin
      flash[:notice] = admin_agent_create_flash_notice_msg
      redirect_to admin_agent_redirect_path
    else
      flash.now[:error] = "There was an error while trying to create the new account"
      render :action => 'new'
    end
  end

  def edit
    if current_user.id.to_s == params[:id]
      @agent = current_user
    else
      if current_user.admin?
        @agent = Agent.agents.find(params[:id]) 
      else
        require_admin_or_visitor_account   ##this would be sweet
      end
    end

  end

  def update
    @agent = Agent.find(params[:id])
    if @agent.update_attributes(params[:agent])
      flash[:notice] = "Agent settings updated."
      redirect_to admin_agent_redirect_path
    else 
      flash.now[:error] = "The agent settings could not be updated."
      render :action => "edit"
    end 
  end


  def destroy
    #should we just render inactive the accounts?
    #
  end


  def approve
    @agent = Agent.agents.find(params[:id])
    
    if @agent.approved!
      flash[:notice] = "Agent approved."
    else 
      flash.now[:error] = "The agent settings could not be updated."
    end 
    redirect_to agents_path   
  end

  private

  def admin_agent_create_flash_notice_msg
    if current_user and current_user.admin?
      "New agent created."
    else
      "Your account has been registered. It will be reviewed for activation shortly"
    end
  end
  


end
