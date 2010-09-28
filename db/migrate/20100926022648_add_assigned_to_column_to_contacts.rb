class AddAssignedToColumnToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :assigned_to, :integer
  end

  def self.down
    remove_column :contacts, :assigned_to
  end
end
