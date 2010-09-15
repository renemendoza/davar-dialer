class ContactListsController < ApplicationController

  def index
    @contact_lists =  ContactList.find(:all)
  end

  def new
    @contact_list =  ContactList.new
  end
end
