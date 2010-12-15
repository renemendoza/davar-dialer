class AddStateColumnToAutoCalls < ActiveRecord::Migration
  def self.up
    add_column :auto_calls, :state, :string
  end

  def self.down
    remove_column :auto_calls, :state
  end
end
