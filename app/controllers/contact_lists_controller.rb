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
      flash[:notice] = "Contact list uploaded"
      redirect_to preview_contact_list_path(@contact_list)
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

  def preview
    @contact_list =  ContactList.find(params[:id]) 
  end

  def import
    @contact_list =  ContactList.find(params[:id]) 
    begin
      @contact_list.import_contacts(params[:contact_list])
      flash[:notice] = "Contacts imported"
      redirect_to contact_lists_path
    rescue => e
      flash[:error] = "There was an error importing the requested contacts: #{e.message} "
      redirect_to preview_contact_list_path(params[:id])
    end
  end

  def destroy
    @contact_list =  ContactList.find(params[:id]) 
    begin
      @contact_list.destroy
      flash[:notice] = "Contact List deleted"
      redirect_to contact_lists_path
    rescue => e
      #log this?
      flash[:error] = "There was an error deleting the requested contact list "
      redirect_to contact_list_path(@contact_list)
    end
  end

end
