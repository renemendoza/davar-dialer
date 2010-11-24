class CreateScheduledTasks < ActiveRecord::Migration
  def self.up
    create_table :scheduled_tasks do |t|
      t.string :task_type
      t.integer :agent_id
      t.integer :contact_id
      t.datetime :scheduled_at
      t.datetime :completed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :scheduled_tasks
  end
end
