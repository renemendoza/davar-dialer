When /^I upload a file with (\d+) valid contacts$/ do |c|
  attach_file("contact_list[list]", File.join(::Rails.root.to_s, "features/assets", "demo_contact_list.csv") )
  click_button "Create"
end

Then /^I should see a list with (\d+) contacts$/ do |i|
  page.should have_css("table.contacts tbody tr", :count => i.to_i)
end

Then /^"([^"]*)" should have a new list with (\d+) new contacts$/ do |agent_username, i|
#"
  agent = Agent.find_by_username(agent_username)
  agent.contact_lists.last.contacts.count.should == i.to_i
end

