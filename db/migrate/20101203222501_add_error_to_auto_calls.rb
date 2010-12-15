class AddErrorToAutoCalls < ActiveRecord::Migration
  def self.up
    add_column :auto_calls, :error, :string
  end

  def self.down
    remove_column :auto_calls, :error
  end
end
