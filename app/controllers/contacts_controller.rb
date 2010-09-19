class ContactsController < ApplicationController
  before_filter :require_valid_account

  def dial
    @contact = Contact.find(params[:id])
    current_user.dial(@contact)   #only errors i can get here is that adhearsion is dead raise an error in Telephony::dial
    flash[:notice] = "Call to #{@contact.name} at #{@contact.phone_number_1} is in progress."
    redirect_to contact_list_path(@contact.contact_list)  #to my old contact list please :S
  end

end
