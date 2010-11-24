class ScheduledTasksController < ApplicationController
  def create
    @scheduled_task = ScheduledTask.new(params[:scheduled_task])
    if @scheduled_task.save
      flash[:notice] = "Task successfully scheduled"
    end
    respond_to do |format|
      format.js 
    end
  end

end
