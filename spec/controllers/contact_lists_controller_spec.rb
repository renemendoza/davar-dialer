require 'spec_helper'


describe ContactListsController do

  describe "GET /contact_lists" do
    before(:each) do 
      @contact_list = Factory(:contact_list)
      ContactList.stub!(:find).and_return([@contact_list])
    end

    def do_get
      get :index
    end

    it "should be succesful" do
      do_get
      response.should be_success
    end

    it "should render the index template" do
      do_get
      response.should render_template("index")
    end

    it "should find all lists" do
      ContactList.should_receive(:find).with(:all).and_return([@contact_list])
      do_get
    end

    it "should assign all lists for the view" do
      do_get
      assigns[:contact_lists].should == [@contact_list]
    end

  end

  describe "GET /contact_lists/new" do
    before(:each) do 
      @contact_list = Factory(:contact_list)
      ContactList.stub!(:new).and_return(@contact_list)
    end
    
    def do_get
      get :new
    end

    it "should be succesful" do
      do_get
      response.should be_success
    end

    it "should render the new template" do
      do_get
      response.should render_template("new")
    end

    it "should create a new contact_list" do
      ContactList.should_receive(:new).and_return(@contact_list)
      do_get
    end

    it "should not save the new contact_list" do
      @contact_list.should_not_receive(:save)
      do_get
    end

    it "should assign the new list for the view" do
      do_get
      assigns[:contact_list].should == @contact_list
    end

  end
end

