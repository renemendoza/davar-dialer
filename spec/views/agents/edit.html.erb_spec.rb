require 'spec_helper'

describe "/agents/edit" do

  before(:each) do
    activate_authlogic
    #we are logged in
    @agent = Factory(:agent)
    assigns[:agent] = @agent

    @session = Session.create(@agent)
    assigns[:session] = @session
    render 

  end

  it "should say 'Agent Settings'" do
    rendered.should contain('Agent Settings')
  end
  
  it "should render the edit agent form" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) 
  end

  it "should have a name field" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) do |form|
      form.should have_selector("input[type=text]", :name => "agent[name]")
    end
  end

  it "should have an email address field" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) do |form|
      form.should have_selector("input[type=text]", :name => "agent[email]")
    end
  end

  it "should have a username field" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) do |form|
      form.should have_selector("input[type=text]", :name => "agent[username]")
    end
  end

  it "should have a password field" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) do |form|
      form.should have_selector("input[type=password]", :name => "agent[password]")
    end
  end

  it "should have a password confirmation field" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) do |form|
      form.should have_selector("input[type=password]", :name => "agent[password_confirmation]")
    end
  end

  it "should have a callback number field" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) do |form|
      form.should have_selector("input[type=text]", :name => "agent[ring_to_destination]")
    end
  end

  it "should have an update button" do
    rendered.should have_selector("form[method=post]", :action => agent_path(@agent)) do |form|
      form.should have_selector("button[type=submit]")
    end
  end

  after(:each) do
    Agent.delete_all
  end
end
