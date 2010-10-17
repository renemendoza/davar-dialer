class AddResultLegBResultLegAAnsweredAtLegBAnsweredAtHangedUpBy < ActiveRecord::Migration
  def self.up
    add_column :auto_calls, :result_leg_a, :string
    add_column :auto_calls, :result_leg_b, :string
    add_column :auto_calls, :leg_a_answered_at, :datetime
    add_column :auto_calls, :leg_b_answered_at, :datetime
    add_column :auto_calls, :hangup_by, :string
    add_column :auto_calls, :hangup_at, :datetime
  end

  def self.down
    remove_column :auto_calls, :result_leg_a
    remove_column :auto_calls, :result_leg_b
    remove_column :auto_calls, :leg_a_answered_at
    remove_column :auto_calls, :leg_b_answered_at
    remove_column :auto_calls, :hangup_by
    remove_column :auto_calls, :hangup_at
  end
end
