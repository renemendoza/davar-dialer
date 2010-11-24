class AddDescriptionToScheduledTasks < ActiveRecord::Migration
  def self.up
    add_column :scheduled_tasks, :description, :string
  end

  def self.down
    remove_column :scheduled_tasks, :description
  end
end
