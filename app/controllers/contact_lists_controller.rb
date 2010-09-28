class ContactListsController < ApplicationController

  before_filter :require_admin_account

  def index
    @contact_lists =  ContactList.all
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
    @contact_list =  ContactList.find(params[:id]) #no need to scope
  end

  def edit   #could be renamed as select or assign or something using the rails routing
    @contact_list =  ContactList.find(params[:id]) #no need to scope
    @agents = Agent.approved.agents
  end

  def update
    begin
      if i = ContactList.assign_contacts(params[:contacts])
        flash[:notice] = "#{i} Contacts assigned"
        redirect_to contact_lists_path
      end
    rescue => e
      #log this?
      flash[:error] = "There was an error assigning the requested contact list "
      redirect_to edit_contact_list_path(params[:id])
    end
  end

  #huge ass spec :S
  #
  #

end
