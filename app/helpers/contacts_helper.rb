module ContactsHelper
  #add colors and testing
  def contact_status(c)
    if c.assigned?
      c.agent.name
    else
      "AVAILABLE"
    end
  end
end
