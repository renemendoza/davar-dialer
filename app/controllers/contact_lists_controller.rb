class ContactListsController < ApplicationController

  def index
    @contact_lists =  ContactList.find(:all)
  end

  def new
    @contact_list =  ContactList.new
  end
  

  def create
    @contact_list =  ContactList.new(params[:contact_list])
    if @contact_list.save

      flash[:notice] = "Contact list created"
      redirect_to contact_lists_path
    else
      flash.now[:error] = "There was an error creating the requested contact list"
      render :action => 'new'
    end
  end

  def show
    @contact_list =  ContactList.find(params[:id])
  end
end
