class Agent < ActiveRecord::Base
  include Telephony
  acts_as_authentic do |a|
    a.logged_in_timeout 30.minutes
  end 
  #logout_on_timeout true



  has_many :contact_lists, :foreign_key => :owner_id
  has_many :contacts, :through => :contact_lists
  #has_many :assigned_contacts, :through => :contact_lists, :source => :contacts

  attr_protected :admin, :approved


  def approved!
    self.approved = true
    save
  end

  def self.agents
    where(:admin => nil)
  end


end
