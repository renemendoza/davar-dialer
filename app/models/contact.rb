class Contact < ActiveRecord::Base
  belongs_to :contact_list
  before_validation do
    self.phone_number_1 = phone_number_1.gsub(/[^0-9]/, "") if attribute_present?("phone_number_1")
  end

end
