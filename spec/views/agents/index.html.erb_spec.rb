require 'spec_helper'

include AgentsHelper

describe "/agents/index" do
  before(:each) do
    @agents = [Factory(:agent), Factory(:agent)]
    @admin = Factory(:agent, :admin => true)
    view.stub(:current_user).and_return(@admin)
    render
  end

  it "should include a link to add a new contact_list" do
    rendered.should have_selector("a[href='#{new_contact_list_path}']") 
  end

  it "should include a link to add a new agent" do
    rendered.should have_selector("a[href='#{new_agent_path}']") 
  end

  it "should include an edit link for each agent" do
    @agents.each do |a|
      rendered.should have_selector("a[href='#{edit_agent_path(a)}']") 
    end
  end

  after(:each) do
    Agent.delete_all
  end
end
