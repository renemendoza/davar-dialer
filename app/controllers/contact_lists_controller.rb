class ContactListsController < ApplicationController

  before_filter :require_valid_account

  def index
    @contact_lists =  current_user.contact_lists
  end

  def new
    @contact_list =  ContactList.new
  end
  

  def create
    @contact_list = current_user.contact_lists.build(params[:contact_list])
    if @contact_list.save
      flash[:notice] = "Contact list created"
      redirect_to contact_list_path(@contact_list)
    else
      flash.now[:error] = "There was an error creating the requested contact list"
      render :action => 'new'
    end
  end

  def show
    @contact_list =  current_user.contact_lists.find(params[:id])
  end
end
