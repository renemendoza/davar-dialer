require 'spec_helper'

describe ContactList do

  
  before(:each) do 
    @contact_list = Factory.build(:contact_list_with_uploaded_file)
  end


  it "should be valid" do
    @contact_list.should be_valid
  end
end
