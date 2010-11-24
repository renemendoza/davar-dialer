require 'spec_helper'


describe ContactListsController do
  describe "when a user is authenticated" do
    before(:each) do 
      activate_authlogic  #we should already be logged in
    end


    describe "with admin privileges" do 
      describe "GET /contact_lists/new" do
        before(:each) do 
          @session = Session.create( Factory(:agent, :admin => true) )  #session as administrator
          @contact_list = Factory.build(:contact_list, :id => 1)   #an unsaved contact_list
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

      describe "POST /contact_lists with valid params" do
        before(:each) do 
          @session = Session.create( Factory(:agent, :admin => true) )  #session as administrator
          #@contact_list = Factory.build(:contact_list, :id => 1)   #an unsaved contact_list
          @contact_list = Factory.build(:contact_list_with_uploaded_file)   #sweet
          ContactList.stub!(:new).and_return(@contact_list)
          @params = {"list" => fixture_file_upload( "#{Rails.root}/features/assets/demo_contact_list.csv", 'text/csv') }
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

        it "flash error should be nil" do
          do_post
          flash[:error].should be_nil
        end

        it "should redirect to the preview contact list page" do
          do_post
          #this is not beautiful
          response.should redirect_to(preview_contact_list_url(@contact_list.id))
        end

        after(:each) do 
          ContactList.delete_all
        end
      end


      describe "POST /contact_lists with invalid params" do
        before(:each) do 
          @params = {}
          @session = Session.create( Factory(:agent, :admin => true) )  #session as administrator
        end

        def do_post
          post :create, :contact_list => @params
        end


        it "flash notice should be nil" do
          do_post
          flash[:notice].should be_nil
        end

        it "flash error should not be nil" do
          do_post
          flash[:error].should_not be_nil
        end

        it "should re-render the contact_lists/new template" do
          do_post
          response.should render_template("new")
        end
      end

      describe "GET /contact_lists" do
        before(:each) do 
          @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet
          @session = Session.create( Factory(:agent, :contact_lists => [@contact_list], :admin => true) )
          @current_user = @session.record
          controller.stub!(:current_user).and_return(@current_user)
          ContactList.stub!(:all).and_return([@contact_list])
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
          ContactList.should_receive(:all).and_return([@contact_list])
          #@current_user.should_receive(:contact_lists).and_return([@contact_list])
          do_get
        end

        it "should assign all lists for the view" do
          do_get
          assigns[:contact_lists].should == [@contact_list]
        end

        after(:each) do 
          ContactList.delete_all
        end
      end

      describe "GET /contact_lists/1" do
        before(:each) do 
          @contact_list = Factory(:contact_list_with_uploaded_file, :id => 1)   #sweet
          @session = Session.create( Factory(:agent, :contact_lists => [@contact_list], :admin => true) )
          @current_user = @session.record
          controller.stub!(:current_user).and_return(@current_user)
          ContactList.stub!(:find).with("1").and_return(@contact_list)
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
          #@current_user.contact_lists.should_receive(:find).with("1").and_return(@contact_list)
          ContactList.should_receive(:find).with("1").and_return(@contact_list)
          do_get
        end

        it "should assign the contact_list for the view" do
          do_get
          assigns[:contact_list].should == @contact_list
        end

        after(:each) do 
          ContactList.delete_all
          Agent.delete_all
        end
      end

      describe "GET /contact_lists/edit/1" do
        #assignment of contact_lists 
        before(:each) do 
          @admin = Factory(:agent,  :admin => true)
          @session = Session.create( @admin )
          @contact_list = Factory(:contact_list_with_uploaded_file, :id => 1, :owner => @admin)   #sweet
          @admin.contact_lists << @contact_list
          @current_user = @session.record
          controller.stub!(:current_user).and_return(@current_user)
          ContactList.stub!(:find).with("1").and_return(@contact_list)
          @agents = [Factory(:agent)]
          #Agent.agents).and_return(@agents)
        end

        def do_get
          get :edit, :id => "1"
        end

        it "should be succesful" do
          do_get
          response.should be_success
        end

        it "should render the edit template" do
          do_get
          response.should render_template("edit")
        end

        it "should find the contact list requested" do
          ContactList.should_receive(:find).with("1").and_return(@contact_list)
          do_get
        end

        it "should assign the contact_list for the view" do
          do_get
          assigns[:contact_list].should == @contact_list
        end

        it "should assign the agent for the view" do
          do_get
          assigns[:agents].should == @agents
        end

        after(:each) do 
          ContactList.delete_all
          Agent.delete_all
        end
      end


      describe "PUT /contact_lists/edit/1" do
        before(:each) do 
          @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet
          ContactList.stub(:assign_contacts).and_return(5)
          @agent = Factory(:agent, :admin => nil)
          @session = Session.create( Factory(:agent, :contact_lists => [@contact_list], :admin => true) )
          @params = { "assigned_to" => @agent.id, "id" => @contact_list.contacts.map(&:id) } 
        end

        def do_update
          put :update, :id => @contact_list.id, :contacts => @params
        end

        it "should load the requested contact_list" do
          ContactList.should_receive(:assign_contacts).with(@params).and_return(5)
          do_update
        end

        it "flash notice should not be nil" do
          do_update
          flash[:notice].should_not be_nil
        end   

        it "flash error should be nil" do
          do_update
          flash[:error].should be_nil
        end 

        it "should redirect to the contact_lists_path" do
          do_update
          response.should redirect_to(contact_lists_path)
        end
      end

      describe "GET /contact_lists/1/preview" do
        before(:each) do
          @admin = Factory(:agent,  :admin => true)
          @session = Session.create( @admin )
          @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet

          @current_user = @session.record
          controller.stub!(:current_user).and_return(@current_user)
          ContactList.stub!(:find).with("1").and_return(@contact_list)
        end

        def do_preview
          get :preview, :id => "1"
        end

        it "should be succesful" do
          do_preview
          response.should be_success
        end

        it "should render the preview template" do
          do_preview
          response.should render_template("preview")
        end

        it "should find the contact list requested" do
          ContactList.should_receive(:find).with("1").and_return(@contact_list)
          do_preview
        end

        it "should assign the contact_list for the view" do
          do_preview
          assigns[:contact_list].should == @contact_list
        end

        after(:each) do 
          ContactList.delete_all
          Agent.delete_all
        end
      end

      describe "POST /contact_lists/1/import with valid params" do
        before(:each) do 
          @session = Session.create( Factory(:agent, :admin => true) )  #session as administrator
          @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet
          ContactList.stub!(:find).with("1").and_return(@contact_list)
          @params = {"import_columns" => {"1" => "full_name", "2" => "phone_number_1" }}
        end

        def do_post
          post :import, :id => "1", :contact_list => @params
        end

        it "flash notice should not be nil" do
          do_post
          flash[:notice].should_not be_nil
        end   

        it "flash error should be nil" do
          do_post
          flash[:error].should be_nil
        end 

        it "should redirect to the contact_lists_path" do
          do_post
          response.should redirect_to(contact_lists_path)
        end

        after(:each) do 
          ContactList.delete_all
          Agent.delete_all
        end
      end

      describe "POST /contact_lists/1/import with invalid params" do
        before(:each) do 
          @session = Session.create( Factory(:agent, :admin => true) )  #session as administrator
          @contact_list = Factory(:contact_list_with_uploaded_file)   #sweet
          ContactList.stub!(:find).with("1").and_return(@contact_list)
          @params = {}
        end

        def do_post
          post :import, :id => "1", :contact_list => @params
        end

        it "flash notice should be nil" do
          do_post
          flash[:notice].should be_nil
        end

        it "flash error should not be nil" do
          do_post
          flash[:error].should_not be_nil
        end

        it "should redirect to the preview_contact_list_path" do
          do_post
          response.should redirect_to(preview_contact_list_path("1"))
        end

        after(:each) do 
          ContactList.delete_all
          Agent.delete_all
        end
      end

      after(:each) do 
        Agent.delete_all
        ContactList.delete_all
        Contact.delete_all
      end

    end


    describe "with agent privileges" do 
      before(:each) do 
        @session = Session.create( Factory(:agent) )  #session as agent
        @contact_list = Factory.build(:contact_list, :id => 1)   #an unsaved contact_list
      end

      describe "GET /contact_lists/new" do
        before(:each) do 
          ContactList.stub!(:new).and_return(@contact_list)
        end
        
        def do_get
          get :new
        end

        it "should not be succesful" do
          do_get
          response.should_not be_success
        end

        it "should redirect" do
          do_get
          response.should be_redirect
        end

        it "flash error should not be nil" do
          do_get
          flash[:error].should_not be_nil
        end


        it "should not assign the new list for the view" do
          do_get
          assigns[:contact_list].should be_nil
        end

        after(:each) do 
          @session.destroy
          Agent.delete_all
          ContactList.delete_all
        end
      end


      describe "POST /contact_lists in general" do
        before(:each) do 
          @params = {"list" => fixture_file_upload( "#{Rails.root}/features/assets/demo_contact_list.csv", 'text/csv'), "id" => "1" }
        end

        def do_post
          post :create, :contact_list => @params
        end


        #it "should not create a new contact list from parameters" do
        #  ContactList.should_not_receive(:new).with(@params).and_return(@contact_list)
        #  do_post
        #  @contact_list.id.should be_nil
        #end

        it "flash notice should be nil" do
          do_post
          flash[:notice].should be_nil
        end

        it "flash error should not be nil" do
          do_post
          flash[:error].should_not be_nil
        end

        it "should redirect" do
          do_post
          response.should be_redirect
        end


        after(:each) do 
          @session.destroy
          Agent.delete_all
          ContactList.delete_all
          Contact.delete_all
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

        it "should not be succesful" do
          do_get
          response.should_not be_success
        end

        it "should redirect" do
          do_get
          response.should be_redirect
        end

        it "flash error should not be nil" do
          do_get
          flash[:error].should_not be_nil
        end

        it "should not assign all lists for the view" do
          do_get
          assigns[:contact_lists].should be_nil
        end

        after(:each) do 
          @session.destroy
          Agent.delete_all
          ContactList.delete_all
          Contact.delete_all
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

        it "should not be succesful" do
          do_get
          response.should_not be_success
        end

        it "should redirect" do
          do_get
          response.should be_redirect
        end

        it "flash error should not be nil" do
          do_get
          flash[:error].should_not be_nil
        end

        it "should not assign the list for the view" do
          do_get
          assigns[:contact_list].should be_nil
        end

        after(:each) do 
          @session.destroy
          Agent.delete_all
          ContactList.delete_all
          Contact.delete_all
        end
      end
    end

  end



  describe "when a user is not authenticated" do
    describe "GET /contact_lists/new" do
      def do_get
        get :new
      end

      it "should not be succesful" do
        do_get
        response.should_not be_success
      end

      it "should redirect" do
        do_get
        response.should be_redirect
      end

      it "flash error should not be nil" do
        do_get
        flash[:error].should_not be_nil
      end


      it "should not assign the new list for the view" do
        do_get
        assigns[:contact_list].should be_nil
      end
    end


    describe "POST /contact_lists" do
      def do_post
        post :create, :contact_list => {}
      end

      it "flash notice should be nil" do
        do_post
        flash[:notice].should be_nil
      end

      it "flash error should not be nil" do
        do_post
        flash[:error].should_not be_nil
      end

      it "should redirect" do
        do_post
        response.should be_redirect
      end
    end


    describe "GET /contact_lists" do

      def do_get
        get :index
      end

      it "should not be succesful" do
        do_get
        response.should_not be_success
      end

      it "should redirect" do
        do_get
        response.should be_redirect
      end

      it "flash error should not be nil" do
        do_get
        flash[:error].should_not be_nil
      end

      it "should not assign all lists for the view" do
        do_get
        assigns[:contact_lists].should be_nil
      end
    end


    describe "GET /contact_lists/1" do

      def do_get
        get :show, :id => "1"
      end

      it "should not be succesful" do
        do_get
        response.should_not be_success
      end

      it "should redirect" do
        do_get
        response.should be_redirect
      end

      it "flash error should not be nil" do
        do_get
        flash[:error].should_not be_nil
      end

      it "should not assign the list for the view" do
        do_get
        assigns[:contact_list].should be_nil
      end
    end

  end
end

