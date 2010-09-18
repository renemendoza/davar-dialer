require 'spec_helper'

describe "/agents/new" do
  before(:each) do
    #we are not logged in
    @agent = Factory.build(:agent)
    assigns[:agent] = @agent
    render 
  end

  it "should say 'Agent registration'" do
    rendered.should contain('Agent registration')
  end

  it "should render the new agent form" do
    rendered.should have_selector("form[method=post]", :action => agents_path) 
  end

  it "should have a name field" do
    rendered.should have_selector("form[method=post]", :action => agents_path) do |form|
      form.should have_selector("input[type=text]", :name => "agent[name]")
    end
  end

  it "should have an email address field" do
    rendered.should have_selector("form[method=post]", :action => agents_path) do |form|
      form.should have_selector("input[type=text]", :name => "agent[email]")
    end
  end

  it "should have a username field" do
    rendered.should have_selector("form[method=post]", :action => agents_path) do |form|
      form.should have_selector("input[type=text]", :name => "agent[username]")
    end
  end

  it "should have a password field" do
    rendered.should have_selector("form[method=post]", :action => agents_path) do |form|
      form.should have_selector("input[type=password]", :name => "agent[password]")
    end
  end

  it "should have a password confirmation field" do
    rendered.should have_selector("form[method=post]", :action => agents_path) do |form|
      form.should have_selector("input[type=password]", :name => "agent[password_confirmation]")
    end
  end

  it "should have a callback number field" do
    rendered.should have_selector("form[method=post]", :action => agents_path) do |form|
      form.should have_selector("input[type=text]", :name => "agent[ring_to_destination]")
    end
  end

  it "should have a register button" do
    rendered.should have_selector("form[method=post]", :action => agents_path) do |form|
      form.should have_selector("button[type=submit]")
    end
  end
end
