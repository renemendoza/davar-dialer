require 'spec_helper'


describe "/sessions/new" do
  before(:each) do
    activate_authlogic
    @session = Factory.build(:session)
    assigns[:session] = @session
#    @customer = Factory(:customer)
#    assigns[:customer] = @customer
    render 
  end

  it "should tell you to login to your account" do
    rendered.should contain('Please login to your account')
  end

  it "should render a form to login" do
    rendered.should have_selector("form[method=post]", :action => sessions_path) 
  end

  it "should have a username field" do
    rendered.should have_selector("form[method=post]", :action => sessions_path) do |form|
      form.should have_selector("input[type=text]", :name => "session[username]")
    end
  end

  it "should have a password field" do
    rendered.should have_selector("form[method=post]", :action => sessions_path) do |form|
      form.should have_selector("input[type=password]", :name => "session[password]")
    end
  end

  it "should have a login button" do
    rendered.should have_selector("form[method=post]", :action => sessions_path) do |form|
      form.should have_selector("button[type=submit]")
    end
  end

end
