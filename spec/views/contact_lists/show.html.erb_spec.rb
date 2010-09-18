require 'spec_helper'

include ContactListsHelper

describe "/contact_lists/show" do
  before(:each) do
    @contact_list = Factory(:contact_list_with_uploaded_file)
    render
  end

  it "should tell you the contact list file name" do
    rendered.should include("demo_contact_list.csv")
  end

  it "should include one li element for each contact" do
    rendered.should have_selector("ul.contacts li", :count => @contact_list.contacts.size)
  end

  it "should include a link to add a new contact_list" do
    rendered.should have_selector("a[href='#{new_contact_list_path}']") 
  end

  it "should include a link to the delete the current contact_list" do
    rendered.should have_selector("a[href='#{contact_list_path(@contact_list)}'][data-method='delete']") 
  end


  it "should include a link for the contact_list index" do
    rendered.should have_selector("a[href='#{contact_lists_path}']") 
  end

  after(:each) do
    ContactList.delete_all
  end


end
