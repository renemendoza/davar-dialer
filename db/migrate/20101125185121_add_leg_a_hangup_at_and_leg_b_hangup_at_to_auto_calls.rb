class AddLegAHangupAtAndLegBHangupAtToAutoCalls < ActiveRecord::Migration
  def self.up
    add_column :auto_calls, :leg_a_hangup_at, :datetime
    add_column :auto_calls, :leg_b_hangup_at, :datetime
    remove_column :auto_calls, :hangup_at
  end

  def self.down
    remove_column :auto_calls, :leg_a_hangup_at
    remove_column :auto_calls, :leg_b_hangup_at
    add_column :auto_calls, :hangup_at, :datetime
  end
end
