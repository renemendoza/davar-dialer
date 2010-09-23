module AgentsHelper

  #add colors and testing
  def agent_status(a)
    content_tag(:td) do
      if a.approved? 
        if a.logged_in?
          content_tag(:strong, "ONLINE") 
        elsif a.logged_out?
          content_tag(:strong, "OFFLINE") 
        end
      else
        link_to("Not Approved", agents_approve_path(a), :class => "button_small_yellow") 
      end
    end

  end
end
