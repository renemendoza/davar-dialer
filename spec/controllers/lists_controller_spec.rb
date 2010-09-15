require 'spec_helper'


describe ListsController do
  describe "GET /lists" do
    before(:each) do 
      #@list = Factory(:list)
      @weather = mock_model(List)
    end
    it "concats two strings with spaces" do
  #       helper.concat_strings("this","that").should == "this that"
    end
   end
end

# describe ListsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
