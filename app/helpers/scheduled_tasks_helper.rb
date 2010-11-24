module ScheduledTasksHelper

  def display_task_type(task)
    if task.task_type == "phone_call"
      image_tag("contact24.png", :class => "scheduled_task")
    elsif task.task_type == "email"
      image_tag("new-message24.png", :class => "scheduled_task")
    end
  end
end
