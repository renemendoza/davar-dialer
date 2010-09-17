require 'spec_helper'


describe ContactListsController do
  describe "when a user is authenticated" do
    before(:each) do 
      activate_authlogic  #we should already be logged in
      @session = Session.create( Factory(:agent) )  #basic session, agent has no contact_lists

      @contact_list = Factory.build(:contact_list, :id => 1)   #an unsaved contact_list

    end

    describe "GET /contact_lists/new" do
      before(:each) do 
        #@contact_list = Factory.build(:contact_list)
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
    describe "POST /contact_lists with valid params" do
      before(:each) do 
        @params = {"list" => fixture_file_upload( "#{Rails.root}/features/assets/demo_contact_list.csv", 'text/csv'), "id" => "1" }

      end

      def do_post
        post :create, :contact_list => @params
      end


      it "should create a new contact list from parameters" do
        ContactList.should_receive(:new).with(@params).and_return(@contact_list)
        do_post
        @contact_list.id.should_not be_nil
      end

      it "flash notice should not be nil" do
        do_post
        flash[:notice].should_not be_nil
      end

      it "should redirect to the created contact list " do
        do_post
        #this is not beautiful
        response.should redirect_to(contact_list_url(ContactList.last.id))
      end


      it "flash error should be nil" do
        do_post
        flash[:error].should be_nil
      end



    end

    describe "POST /contact_lists with invalid params" do
      before(:each) do 
        #@params = {"list" => fixture_file_upload( "#{Rails.root}/features/assets/demo_contact_list.csv", 'text/csv') }
        @params = {}
      end

      def do_post
        post :create, :contact_list => @params
      end

      it "should not be successful" do
        pending
      end
      
      it "flash error should not be nil" do
        pending
      end

      it "should re-render the contact_lists/new template" do
        pending
      end
    end


    describe "GET /contact_lists" do
      before(:each) do 
        @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet
        @session = Session.create( Factory(:agent, :contact_lists => [@contact_list]) )
        @current_user = @session.record
        controller.stub!(:current_user).and_return(@current_user)
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
        @current_user.should_receive(:contact_lists).and_return([@contact_list])
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
        @session = Session.create( Factory(:agent, :contact_lists => [@contact_list]) )
        @current_user = @session.record
        @current_user.contact_lists.stub!(:find).with("1").and_return(@contact_list)
        controller.stub!(:current_user).and_return(@current_user)
      end

      def do_get
        get :show, :id => "1"
      end

      it "should be succesful" do
        do_get
        response.should be_success
      end

      it "should render the show template" do
        do_get
        response.should render_template("show")
      end

      it "should find the contact list requested" do
        @current_user.contact_lists.should_receive(:find).with("1").and_return(@contact_list)
        do_get
      end

      it "should assign the contact_list for the view" do
        do_get
        assigns[:contact_list].should == @contact_list
      end

    end

  end
end

