module ContactsHelper
  #add colors and testing
  def contact_status(c)
    if c.assigned?
      c.agent.name
    else
      "AVAILABLE"
    end
  end

  def amd_status(a)
    if a.use_amd?
      link_to(content_tag(:strong, "ON"), edit_agent_path(a)) 
    else
      link_to(content_tag(:strong, "OFF"), edit_agent_path(a)) 
    end
  end
end
