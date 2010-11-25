require 'spec_helper'

describe ContactsController do
  describe "when a user is authenticated" do
    before(:each) do 
      activate_authlogic  #we should already be logged in
    end

    #can not mock out adhearsion :S
    #
    describe "when there are no telephony errors" do
      before(:each) do 
        @contact_list = Factory(:contact_list_with_uploaded_file)   #saved contact_list
        @agent = Factory(:agent, :contact_lists => [@contact_list])
        #@session = Session.create( Factory(:agent, :contact_lists => [@contact_list]) )
        @session = Session.create( @agent )
        @current_user = @session.record

        controller.stub!(:current_user).and_return(@current_user)
        @contact = @current_user.contact_lists.first.contacts.first

        @contact = @current_user.contact_lists.first.contacts.first
        #@current_user.stub!(:dial).and_return(true)    #no telephony errors
        @current_user.stub!(:dial).and_return(Telephony::TelephonyError)    #telephony errors
        #@current_user.contacts.stub!(:find).with("1").and_return(@contact)
        @current_user.stub!(:assigned_contacts).and_return(@contact_list.contacts)    #telephony errors
        @current_user.assigned_contacts.stub!(:find).with("1").and_return(@contact)
      end

      describe "GET /contacts" do
        def do_get
          get :index
        end

        it "should assign the contacts for the view" do
          pending
        end

      end

      describe "GET /contacts/dial/1" do

        def do_get
          get :dial, :id => "1"
        end

        it "should redirect" do
          @current_user.assigned_contacts.should_receive(:find).and_return(@contact)
          do_get 
          response.should be_redirect
        end

        it "should find the specified contact" do
          @current_user.assigned_contacts.should_receive(:find).and_return(@contact)
          do_get 
          @contact.id.should_not be_nil
        end

        it "flash notice should not be nil" do
          do_get
          flash[:notice].should_not be_nil
        end

        it "flash error should be nil" do
          do_get
          flash[:error].should be_nil
        end

        it "should call dial and not throw errors" do
          pending
        end
      end

      after(:each) do
        ContactList.delete_all
        Contact.delete_all
        Agent.delete_all
      end
    end

    describe "when there are telephony errors" do
      before(:each) do 
      end

      describe "GET /contacts/dial/1" do
        def do_get
          get :dial, :id => "1"
        end
        it "should call dial and get errors" do
          pending
        end
      end

      after(:each) do
      end
    end


  end
end
