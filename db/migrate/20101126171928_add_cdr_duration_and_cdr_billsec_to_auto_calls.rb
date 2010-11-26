class AddCdrDurationAndCdrBillsecToAutoCalls < ActiveRecord::Migration
  def self.up
    add_column  :auto_calls, :cdr_duration, :integer, :default => 0
    add_column  :auto_calls, :cdr_billsec, :integer, :default => 0
  end

  def self.down
    remove_column  :auto_calls, :cdr_duration
    remove_column  :auto_calls, :cdr_billsec
  end
end
