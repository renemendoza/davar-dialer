When /^I upload a file with (\d+) valid contacts$/ do |c|
  visit new_contact_list_url
  attach_file("contact_list[list]", File.join(::Rails.root.to_s, "features/assets", "demo_contact_list.csv") )
  click_button "Create"
end

When /^I choose the first column as name and the second column as phone number$/ do
  select('Full Name', :from => 'contact_list_import_columns_1')
  select('Phone Number 1', :from => 'contact_list_import_columns_2')
  click_button "Import Contacts"
end

When /^I import it$/ do
  select('Full Name', :from => 'contact_list_import_columns_1')
  select('Phone Number 1', :from => 'contact_list_import_columns_2')
  click_button "Import Contacts"
end


When /^I choose to skip the first row$/ do
  check('Skip first row')
end


Then /^"([^"]*)" should have a new list with (\d+) new contacts$/ do |agent_username, i|
#"
  agent = Agent.find_by_username(agent_username)
  agent.contact_lists.last.contacts.count.should == i.to_i
end


Then /^"([^"]*)" should have (\d+) list with (\d+) new contacts$/ do |agent_username, lists_count, contacts_count|
#"
  agent = Agent.find_by_username(agent_username)
  agent.contact_lists.count.should == lists_count.to_i
  agent.contact_lists.last.contacts.count.should == contacts_count.to_i
end

Then /^I should see a list with (\d+) contacts$/ do |i|
  page.should have_css("table.contacts tbody tr", :count => i.to_i)
end


When /^I choose contact number (\d+) and contact number (\d+)$/ do |arg1, arg2|
  within("table.contacts tbody") do
    find("tr:nth-of-type(#{arg1.to_i}) td:nth-of-type(1) input").set(true)
    find("tr:nth-of-type(#{arg2.to_i}) td:nth-of-type(1) input").set(true)
  end
end

When /^I choose agent "([^"]*)"$/ do |agent_name|
#"
  agent = Agent.find_by_name(agent_name)
  within("table.agents tbody") do
    choose(agent.name)
  end
end


After do |scenario|  
  if scenario.status == :failed
    save_and_open_page
  end  
end


