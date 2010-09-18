class AgentsController < ApplicationController
  #should protect all actions except new and create
  before_filter :require_valid_account, :except => [:new, :create]
 
  def index
  end

  def new
    @agent = Agent.new
  end

  def create
    @agent = Agent.new(params[:agent])
    if @agent.save
      Session.create(@agent, true) #autologin
      flash[:notice] = "New agent created."
      redirect_to contact_lists_path
    else
      flash.now[:error] = "There was an error while trying to register your account"
      render :action => 'new'
    end
  end

  def edit
    @agent = current_user  #except when we want an admin editing other dudes
  end

  def update
    @agent = Agent.find(params[:id])
    if @agent.update_attributes(params[:agent])
      flash[:notice] = "Agent settings updated."
      redirect_to contact_lists_path
    else 
      flash.now[:error] = "The agent settings could not be updated."
      render :action => "edit"
    end 
  end

  


end
