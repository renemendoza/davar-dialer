require 'spec_helper'


describe ContactListsController do

  describe "GET /contact_lists" do
    before(:each) do 
      @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet
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

  describe "GET /contact_lists/1" do
    before(:each) do 
      @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet
      ContactList.stub!(:find).and_return(@contact_list)
    end

    def do_get
      get :show, :id => "1"
    end

    it "should be succesful" do
      do_get
      response.should be_success
    end

  end

  describe "GET /contact_lists/new" do
    before(:each) do 
      @contact_list = Factory.build(:contact_list)
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


  #with valid params
  describe "POST /contact_lists" do
    before(:each) do 
      @contact_list = Factory.build(:contact_list)
      @params = {"list" => fixture_file_upload( "#{Rails.root}/features/assets/demo_contact_list.csv", 'text/csv') }
    end

    def do_post
      post :create, :contact_list => @params
    end

    it "should create a new contact list from parameters" do
      ContactList.should_receive(:new).with(@params).and_return(@contact_list)
      @contact_list.should_receive(:save)
      do_post
    end

    it "flash notice should not be nil" do
      do_post
      flash[:notice].should_not be_nil
    end

    it "flash error should be nil" do
      do_post
      flash[:error].should be_nil
    end

    it "should redirect to the contact list listing" do
      do_post
      response.should redirect_to(contact_lists_path)
    end


  end
end

