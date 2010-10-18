class ContactList < ActiveRecord::Base
  has_attached_file :list
  belongs_to :owner, :class_name => "Agent"

  has_many :contacts, :dependent => :destroy

  has_many :unassigned_contacts, :class_name => "Contact", :conditions => "assigned_to is NULL"
  has_many :assigned_contacts, :class_name => "Contact", :conditions => "assigned_to is NOT NULL"
  #
  accepts_nested_attributes_for :contacts  #?

  validates_attachment_presence :list

  validates_attachment_content_type :list, :content_type => ['text/csv','text/comma-separated-values','text/csv','application/csv','application/excel','application/vnd.ms-excel','application/vnd.msexcel','text/anytext','text/plain']

  COLUMN_NAMES = ["Full Name", "First Name", "Last Name", "Street Address", "City", "State", "Phone Number 1", "Phone Number 2", "Resort"]
  COLUMN_NAMES_HEADERS = COLUMN_NAMES.collect {|c| [c, c.parameterize.underscore]}

  def list_contents(limit=0, &block)
    list_contents_for_excel_file(limit, &block) if is_excel?
    list_contents_for_csv_file(limit, &block) if is_csv?
  end
  
  def count_columns
    return count_columns_for_csv_file if is_csv?
    return count_columns_for_excel_file if is_excel?
  end

  def import_columns
  end


  def import_contacts(params)
   # MOVE THIS TO RESQUE background_job style  (for long lists with 100s of contacts)
    i = 0
    column_map = {}
    params[:import_columns].reject {|k,v| v.blank? }.each {|k,v| column_map[v.to_sym] = (k.to_i - 1) }
    #before this runs, we need to analize the column map to see if it has at least the minimum fields 
    attrs = {}

    #MAP columns to fields using lambda
    #
    if column_map.include?(:full_name)
      attrs[:name] = lambda {|row| row[ column_map[:full_name] ] }

    elsif column_map.include?(:first_name) && column_map.include?(:last_name)
      attrs[:name] = lambda {|row| row[ column_map[:first_name] ] + " " + row[ column_map[:last_name] ]  }

    else
      if column_map.include?(:first_name) 
        attrs[:name] = lambda {|row|  row[ column_map[:first_name] ] }
      elsif column_map.include?(:last_name) 
        attrs[:name] = lambda {|row|  row[ column_map[:last_name] ] }
      end
    end

    [:street_address, :city, :state, :phone_number_1, :resort].each do |c|
      if column_map.include?(c) 
        attrs[c] = lambda {|row|  row[ column_map[c] ] }
      end
    end
    
    # ITERATE  tru every record in the file according to its file type 
    list_contents do |row|      
      unless i == 0 && params[:skip_first_row] == "on"  
      #skip first row if flag on
        insert_contact_from_row(row, attrs)
      end
      i+=1
    end 
   # raise "#{self.list.queued_for_write[:original].inspect} "
   #
   
  end


  private

  def insert_contact_from_row(row, attrs)
  #  INSERT the corresponding records
    params = {}
    attrs.each {|k,v| params[k] = v.call(row)}
    self.contacts << Contact.create(params)
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

  def is_excel?
    unless list.nil?
      return true if list.content_type =~ /excel/
    end
    return false
  end

  def is_csv?
    unless list.nil?
      return true if list.content_type =~ /csv/
    end
    return false
  end

  def count_columns_for_csv_file
    file = File.open(list.path)
    cols_count = file.readline.split(",").size
    file.close
    return cols_count
  end

  def list_contents_for_csv_file(limit=0, &block)
    File.open(list.path).each_with_index do |line, i|
      yield line.split(",")
      break if i == limit unless limit == 0
    end
    ""
  end

  def count_columns_for_excel_file
    xls = Excel.new(list.path) 
    xls.default_sheet = xls.sheets.first
    xls.row(xls.first_row).size
  end

  def list_contents_for_excel_file(limit=0, &block)
    xls = Excel.new(list.path) 
    xls.default_sheet = xls.sheets.first

    1.upto(xls.last_row) do |i| 
      yield xls.row(i)
      break if i == limit unless limit == 0
    end 

  end

end
