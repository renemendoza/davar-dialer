class Contact < ActiveRecord::Base
  belongs_to :contact_list
  belongs_to :agent, :foreign_key => :assigned_to

  has_many :auto_calls

  #counter_cache auto_calls seria bueno

  before_validation do
    self.phone_number_1 = phone_number_1.gsub(/[^0-9]/, "") if attribute_present?("phone_number_1")
  end
  
  def assigned?
    ! agent.nil?  
  end


end
