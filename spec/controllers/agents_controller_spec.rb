require 'spec_helper'

describe AgentsController do

  describe "unauthenticated users" do

    describe "GET /agents/new" do

      before(:each) do 
        @agent = Factory.build(:agent_blank)
        Agent.stub!(:new).and_return(@agent)

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


      it "should create a new agent" do
        Agent.should_receive(:new).and_return(@agent)
        do_get
      end

      it "should not save the new agent" do
        @agent.should_not_receive(:save)
        do_get
      end

      it "should assign the new agent for the view" do
        do_get
        assigns[:agent].should == @agent
      end

    #agent should be not approved 

    end

    describe "POST /agents" do
 
      before(:each) do 
        @agent = Factory.build(:agent)
        @params = @agent.attributes

        Agent.stub!(:new).and_return(@agent)

      end

      def do_post
        post :create, :agent => @params
      end

      it "should create a new agents from valid data " do
        Agent.should_receive(:new).with(@params).and_return(@agent)
        @agent.should_receive(:save)
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

      it "should redirect to the login path (as agent is un-approved)" do
        do_post
        response.should redirect_to(login_path)
      end

      after(:each) do 
        Agent.delete_all
      end
    end

  end

  describe "authenticated users with admin privileges" do 
#    before(:each) do 
#    end

    describe "GET /agents/" do
      before(:each) do 
        activate_authlogic  #we are logged in
        @agent = Factory.build(:agent, :admin => true)
        @session = Session.create(@agent)
        @agents = [ Factory(:agent) ]
        Agent.stub!(:agents).and_return(@agents)
      end

      def do_get
        get :index
      end

      it "should be succesful" do
        do_get
        response.should be_success
      end

      it "should find all the agents" do
        Agent.should_receive(:agents).and_return(@agents)
        do_get
      end

      it "should render the index template" do
        do_get
        response.should render_template("index")
      end

      it "should assign  the list of agents for the view" do
        do_get
        assigns[:agents].should == @agents
      end


      after(:each) do 
        @session.destroy
        Agent.delete_all
      end

    end

    describe "GET /agents/edit/1" do
      before(:each) do 
        activate_authlogic  #we are logged in
        @agent = Factory(:agent)
        @session = Session.create(@agent)

      end

      def do_get
        get :edit, :id => @agent
      end

      it "should be succesful" do
        do_get
        response.should be_success
      end

      it "should render the edit template" do
        do_get
        response.should render_template("edit")
      end

      #it "should load the requested agent" do
        #do_get
        #can not test properly at this time due to scoping
      #end

      it "should assign the requested agent for the view" do
        do_get
        assigns[:agent].should == @agent
      end


      after(:each) do 
        @session.destroy
        Agent.delete_all
      end

    end
    describe "PUT /agents/edit/1" do
      before(:each) do 
        activate_authlogic  #we are logged in
        @agent = Factory(:agent)
        @session = Session.create(@agent)
        Agent.stub!(:find).and_return(@agent)
        @agent.stub!(:update_attributes).and_return(true)

      end

      def do_update
        put :update, :id => @agent
      end

      it "should load the requested agent" do
        Agent.should_receive(:find).and_return(@agent)
        do_update
      end

      it "should update the agent's attributes" do
        @agent.should_receive(:update_attributes).and_return(true)
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
        response.should redirect_to(contact_lists_url)
      end

      after(:each) do 
        @session.destroy
        Agent.delete_all
      end

    end

  end

  describe "authenticated users without admin privileges" do 
    describe "GET /agents/" do
      before(:each) do 
        activate_authlogic  #we are logged in
        @agent = Factory.build(:agent)
        @session = Session.create(@agent)
        @agents = [ Factory(:agent) ]
      end

      def do_get
        get :index
      end

      it "should be succesful" do
        do_get
        response.should_not be_success
      end

      it "should not render the index template" do
        do_get
        response.should_not render_template("index")
      end

      it "should not assign the list of agents for the view" do
        do_get
        assigns[:agents].should_not == @agents
      end


      after(:each) do 
        @session.destroy
        Agent.delete_all
      end

    end


    describe "GET /agents/new" do

      before(:each) do 
        activate_authlogic  #we are logged in
        @session = Session.create(Factory(:agent))
        @agent = Factory.build(:agent)
        Agent.stub!(:new).and_return(@agent)
      end

      def do_get
        get :new
      end

      it "should not be succesful" do
        do_get
        response.should_not be_success
      end

      it "should not render the new template" do
        do_get
        response.should_not render_template("new")
      end

      it "should redirect" do
        do_get
        response.should be_redirect
      end

      it "flash error should not be nil" do
        do_get
        flash[:error].should_not be_nil
      end

      it "should not assign the new agent for the view" do
        do_get
        assigns[:agent].should_not == @agent
      end

      after(:each) do 
        @session.destroy
        Agent.delete_all
      end

    end

    describe "POST /agents" do
 
      before(:each) do 
        activate_authlogic  #we are logged in
        @session = Session.create(Factory(:agent))

        @agent = Factory.build(:agent)
        @params = @agent.attributes
        Agent.stub!(:new).and_return(@agent)

      end

      def do_post
        post :create, :agent => @params
      end

      it "should not be succesful" do
        do_post
        response.should_not be_success
      end

      it "flash error should not be nil" do
        do_post
        flash[:error].should_not be_nil
      end 

      #a nice test would be to see if the agent count goes up or not
      #:D

      after(:each) do 
        @session.destroy
        Agent.delete_all
      end
    end


  end
end
