module ContactsHelper
  #add colors and testing
  def contact_assignment_status(c)
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

  def call_history(c)
    if c.auto_calls_count > 0
      link_to(content_tag(:strong, "#{c.auto_calls_count}"), contact_calls_path(c)) 
    else
      c.auto_calls_count
    end
  end

  def contact_preview_row(row)
    content_tag(:tr) do
      row.collect {|cell| concat(content_tag(:td, cell))  }
    end
  end


end
