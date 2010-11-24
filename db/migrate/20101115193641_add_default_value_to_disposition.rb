class AddDefaultValueToDisposition < ActiveRecord::Migration
  def self.up
    change_column :contacts, :disposition, :string, :default => "new"
  end

  def self.down
    change_column :contacts, :disposition, :string
  end
end
