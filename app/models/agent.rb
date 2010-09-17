class Agent < ActiveRecord::Base
  acts_as_authentic
  has_many :contact_lists, :foreign_key => :owner_id
end
