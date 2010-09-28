require 'spec_helper'

describe "/contact_lists/edit" do

  include ContactListsHelper

  before(:each) do
    @contact_list = Factory(:contact_list_with_uploaded_file)
    @agents = [Factory(:agent, :admin => nil)]
    render 
  end

  it "should say contact list assignment" do
    rendered.should include("Contact List Assignment")
  end

  it "should render a form to assign the agents" do
    rendered.should have_selector("form[method=post]", :action => contact_list_path(@contact_list)) 
  end

  it "should include one row for each contact" do
    rendered.should have_selector("table.contacts tbody tr", :count => @contact_list.contacts.size)
  end

  it "should include one row for each agent" do
    rendered.should have_selector("table.agents tbody tr", :count => @agents.size)
  end

  it "should have an assign button" do
    rendered.should have_selector("form[method=post]", :action => contact_list_path(@contact_list)) do |form|
      form.should have_selector("button[type=submit]")
    end
  end

  after(:each) do
    ContactList.delete_all
    Agent.delete_all
    Contact.delete_all
  end
end
