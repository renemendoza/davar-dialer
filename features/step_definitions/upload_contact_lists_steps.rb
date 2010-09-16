When /^I upload a file with (\d+) valid contacts$/ do |c|
  attach_file("contact_list[list]", File.join(::Rails.root.to_s, "features/assets", "demo_contact_list.csv") )
  click_button "Create"
end


Then /^I should have a new list with (\d+) contacts$/ do |i|
  Contact.count.should == i.to_i
end
