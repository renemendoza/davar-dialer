class CallsController < ApplicationController
  before_filter :require_valid_account

  def index
    @contact = current_user.assigned_contacts.find(params[:contact_id])
    @calls = @contact.auto_calls
  end


  def show
    @auto_call = AutoCall.find(params[:id])
    #include the contact name
    respond_to do |format|
      format.js { render :json => @auto_call.to_json(:only => [:id, :action_id], :methods => :state)  }
    end
  end

  def update
    @auto_call = AutoCall.find(params[:id])
    if @auto_call.update_attributes(params[:auto_call])
    end
    respond_to do |format|
      format.js { render :json => @auto_call }
    end
  end


end
