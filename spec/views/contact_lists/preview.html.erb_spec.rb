require 'spec_helper'

describe "/contact_lists/preview" do

  include ContactListsHelper

  before(:each) do
    @contact_list = Factory(:contact_list_with_uploaded_file)
    @agents = [Factory(:agent, :admin => nil)]
    render 
  end

  it "should say contact list assignment" do
    rendered.should include("Contact List Preview")
  end

  it "should render a form to map columns in the file to fields" do
    rendered.should have_selector("form[method=post]", :action => import_contact_list_path(@contact_list)) 
  end

  it "should include one row for each contact" do
    pending #how to  know how many lines we are showing, maybe just say it has more than one row?
#    rendered.should have_selector("table.contacts tbody tr", :count => @contact_list.contacts.size)
  end


  it "should have an import contacts button" do
    rendered.should have_selector("form[method=post]", :action => import_contact_list_path(@contact_list)) do |form|
      form.should have_selector("button[type=submit]")
    end
  end

  after(:each) do
    ContactList.delete_all
    Agent.delete_all
    Contact.delete_all
  end
end
