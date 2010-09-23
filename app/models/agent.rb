class Agent < ActiveRecord::Base
  include Telephony
  acts_as_authentic
  has_many :contact_lists, :foreign_key => :owner_id
  has_many :contacts, :through => :contact_lists
  #has_many :assigned_contacts, :through => :contact_lists, :source => :contacts
  #after_create :automatic_login
  #validations?

#private
#  def automatic_login
#    Session.create(self, true) 

#  Session.create(:email => @user.email, :password => @user.password) 
#  end
end
