Factory.define :agent do |f|
  f.sequence(:name) {|n| "Johnny#{n}"}
  f.sequence(:username) {|n| "john#{n}"}
  f.sequence(:email) {|n| "johny_test#{n}@gmail.com"}
  f.password "123456"
  f.password_confirmation  { |u| u.password }
end

Factory.define :contact_list do |c| 
end

Factory.define :contact_list_with_uploaded_file, :class => ContactList do |c| 
  c.list  { fixture_file_upload( "#{Rails.root}/features/assets/demo_contact_list.csv", 'text/csv') }
  c.owner {|owner| owner.association(:agent) }
  c.contacts {|contacts| [contacts.association(:contact)] }

end

def generate_nanpa_phone_number
  #move this to app/models/contact.rb or to a helper and create a test for it
  chars = ('0'..'9').to_a
  chars[2,8][rand(8)] + (1..9).collect{|a| chars[rand(chars.size)] }.join
end

Factory.define :contact do |c| 
  c.sequence(:name) { |n| "John#{n}" }
  c.sequence(:phone_number_1) { |n| generate_nanpa_phone_number }
end

Factory.define :session do |s| 
end


Factory.define :agent_blank, :class => Agent do |f|
end
