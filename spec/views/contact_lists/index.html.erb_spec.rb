require 'spec_helper'

include ContactListsHelper

describe "/contact_lists/index" do
  before(:each) do
    @contact_lists = [Factory(:contact_list_with_uploaded_file)]
    @contact_lists << Factory(:contact_list_with_uploaded_file)
    render
  end

  it "should say 'Your contact lists'" do
    rendered.should include("Your contact lists")
  end

  it "should include a link to add a new contact_list" do
    rendered.should have_selector("a[href='#{new_contact_list_path}']") 
  end

  it "should include a show link for each contact_list" do
    @contact_lists.each do |c|
      rendered.should have_selector("a[href='#{contact_list_path(c)}']") 
    end
  end
end
