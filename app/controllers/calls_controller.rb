class CallsController < ApplicationController
  before_filter :require_valid_account

  def index
    @contact = current_user.assigned_contacts.find(params[:contact_id])
    @calls = @contact.auto_calls
  end

  def show
  end

end
