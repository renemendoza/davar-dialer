class Agent < ActiveRecord::Base
  include Telephony
  acts_as_authentic do |a|
    a.logged_in_timeout 30.minutes
  end 
    #logout_on_timeout true syntax?


  #admins
  has_many :contact_lists, :foreign_key => :owner_id
  has_many :contacts, :through => :contact_lists
  
  #agents
  has_many :assigned_contacts, :foreign_key => :assigned_to, :class_name => "Contact"

  attr_protected :admin, :approved


  def approved!
    self.approved = true
    save
  end

  def self.agents
    where(:admin => nil)
  end

  def self.approved
    where(:approved => true)
  end


end
