class ContactList < ActiveRecord::Base
  has_attached_file :list
  belongs_to :owner, :class_name => "Agent"

  has_many :contacts

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
end
