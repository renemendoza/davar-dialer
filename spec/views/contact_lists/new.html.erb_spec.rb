require 'spec_helper'

describe "/contact_lists/new" do

  include ContactListsHelper

  before(:each) do
    @contact_list = Factory.build(:contact_list)
    render 
  end

  it "should tell you upload a contact list file" do
    rendered.should include("Adding a new contact list")
  end

  it "should render a form to upload a new list" do
    rendered.should have_selector("form[method=post]", :action => contact_lists_path) 
  end

  it "should have a list upload file field" do
    rendered.should have_selector("form[method=post]", :action => contact_lists_path) do |form|
      form.should have_selector("input[type=file]", :name => "contact_list[list]")
    end
  end

  it "should have a create button" do
    rendered.should have_selector("form[method=post]", :action => contact_lists_path) do |form|
      form.should have_selector("button[type=submit]")
    end
  end
end
