module AgentsHelper

  def approved_link(a)
    content_tag(:td) do
      if a.approved? 
        content_tag(:strong, "YES")
      else
        link_to("Not Approved", agents_approve_path(a), :class => "button_small_yellow") 
      end
    end

      # <%= link_to "Approve", "#", :class => "button_small_green" -%> 
      #<td> <%= a.approved? %> </td>
      #<td> <%= link_to "Approve", "#", :class => "button_small_green" -%> </td>
  end
end
