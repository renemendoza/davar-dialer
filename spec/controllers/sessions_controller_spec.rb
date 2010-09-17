require 'spec_helper'


describe SessionsController do

  describe "GET /login" do
    before(:each) do 
      activate_authlogic
      @session = Factory.build(:session)
      Session.stub!(:new).and_return(@session)
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

    it "should create a new session" do
      Session.should_receive(:new).and_return(@contact_list)
      do_get
    end

    it "should not save the new session" do
      @session.should_not_receive(:save)
      do_get
    end

    it "should assign the new session for the view" do
      do_get
      assigns[:session].should == @session
    end

  end

  describe "POST /sessions  " do
  #LOGIN

    describe "with valid credentials" do
      before(:each) do 
        #activate_authlogic

        @agent = Factory(:agent)
        @params = {"username" => @agent.username, "password" => @agent.password}

        @session = Factory.build(:session)
        #Session.stub(:new).with(@params) { @session }
      end

      def do_post
        post :create, :session => @params
      end

      it "should create a new session from valid credentials " do
        Session.should_receive(:new).with(@params).and_return(@session)
        @session.should_receive(:save)
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

    describe "with invalid data" do

      before(:each) do 
        @agent = Factory.build(:agent)
        @params = {"username" => @agent.username, "password" => @agent.password}

        @session = Factory.build(:session)

      end

      def do_post
        post :create, :session => @params
      end

      it "flash notice should be nil" do
        do_post
        flash[:notice].should be_nil
      end   

      it "flash error should not be nil" do
        do_post
        flash[:error].should_not be_nil
      end 

      it "should re-render the 'new' template" do
        do_post
        response.should render_template("new")
      end

    end

  end

  describe "DELETE /sessions" do
    #LOGOUT
    before(:each) do
      activate_authlogic

      @session = Session.create(Factory.build(:agent))
    end

    it "destroys the requested user session" do
      Session.should_receive(:find).and_return(@session)
      @session.should_receive(:destroy)
      delete :destroy
    end

    it "should redirect to the log in page" do
      delete :destroy
      response.should redirect_to(login_url)
    end

    it "flash notice should not be nil" do
      delete :destroy
      flash[:notice].should_not be_nil
    end   
  end
end
