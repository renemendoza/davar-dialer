class ContactsController < ApplicationController
  before_filter :require_valid_account




  rescue_from Telephony::TelephonyError, :with => :telephony_error
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found_error


  def index
    @contacts = current_user.assigned_contacts
    @myself = current_user
  end

  def edit   #could be renamed to something else using rails routing but i am not sure to what
    @contact = current_user.assigned_contacts.find(params[:id])    #nicely scoped
    @scheduled_task  = ScheduledTask.new(:agent_id => current_user.id, :contact_id => @contact.id)
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Successfully updated contact."
    end 

    respond_to do |format|
      format.js 
    end
  end

  def preview_dial
    @contact = current_user.assigned_contacts.find(params[:id]) 
    @scheduled_task  = ScheduledTask.new(:agent_id => current_user.id, :contact_id => @contact.id)
  end

  def dial
    @contact = current_user.assigned_contacts.find(params[:id]) 
    @auto_call = current_user.dial(@contact)     

    flash[:notice] = "Call to #{@contact.name} at #{@contact.phone_number_1} is in progress."

    respond_to do |format|
      format.html { redirect_to contacts_path }
      format.js { render :json => @auto_call }
    end
  end

  def wrap_up
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Succesfully wrapped call."
    end 

    respond_to do |format|
      format.html { redirect_to dialer_next_path }
    end
  end



  private
  #my errors, can we refactor?

  def telephony_error(ex)
      flash[:error] = "Call to #{@contact.name} at #{@contact.phone_number_1} failed #{ex.message}."
      redirect_to contacts_path 
  end
  
  def record_not_found_error(ex)
      flash[:error] = "Call failed: That record does not exist #{ex.message}."
      redirect_to contacts_path 
  end

  def dialer_next_path
      next_contact = current_user.assigned_contacts.next
      unless next_contact.nil?
        contacts_preview_dial_path(next_contact)
      else
        contacts_path
      end
  end

end
