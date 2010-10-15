class CreateAutoCalls < ActiveRecord::Migration
  def self.up
    create_table :auto_calls do |t|
      t.integer :contact_id
      t.integer :agent_id
      t.string :amd
      t.string :phone_number
      t.string :action_id
      t.string :unique_id_a
      t.string :unique_id_b

      t.timestamps
    end
  end

  def self.down
    drop_table :auto_calls
  end
end
