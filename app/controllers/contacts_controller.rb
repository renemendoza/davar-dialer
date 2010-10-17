class ContactsController < ApplicationController
  before_filter :require_valid_account

  rescue_from Telephony::TelephonyError, :with => :telephony_error
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found_error


  def index
    @contacts = current_user.assigned_contacts
  end

  def dial
    @contact = current_user.assigned_contacts.find(params[:id])    #nicely scoped
    current_user.dial(@contact)   
    flash[:notice] = "Call to #{@contact.name} at #{@contact.phone_number_1} is in progress."
    redirect_to contacts_path  
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

end
