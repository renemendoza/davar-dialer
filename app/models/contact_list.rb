class ContactList < ActiveRecord::Base
  has_attached_file :list
  belongs_to :owner, :class_name => "Agent"

  has_many :contacts

  has_many :unassigned_contacts, :class_name => "Contact", :conditions => "assigned_to is NULL"
  has_many :assigned_contacts, :class_name => "Contact", :conditions => "assigned_to is NOT NULL"
  #
  accepts_nested_attributes_for :contacts  #?

  validates_attachment_presence :list

  validates_attachment_content_type :list, :content_type => ['text/csv','text/comma-separated-values','text/csv','application/csv','application/excel','application/vnd.ms-excel','application/vnd.msexcel','text/anytext','text/plain']

  after_save :create_contacts 

  private
  def create_contacts
   # raise "#{self.list.queued_for_write[:original].inspect} "
    #
    # MOVE THIS TO RESQUE background_job style
    
     File.open(self.list.path).each do |line|
      line.chomp!
      name, phone_number_1 = line.split(",")
      self.contacts << Contact.create(:name => name, :phone_number_1 => phone_number_1)
     end 
      
  end

  def self.assign_contacts(params)
    @agent = Agent.find(params.delete(:assigned_to))
    contacts = Contact.find(params.delete(:id))
    i = 0
    contacts.each do |contact|
      contact.agent = @agent
      if contact.save
        i += 1
      end
    end 
    return i
  end
end
