class AddAutoCallsCounterCacheColumnToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :auto_calls_count, :integer, :default => 0
  end

  def self.down
    remove_column :contacts, :auto_calls_count
  end
end
