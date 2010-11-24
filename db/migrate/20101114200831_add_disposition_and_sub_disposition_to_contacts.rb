class AddDispositionAndSubDispositionToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :disposition, :string
    add_column :contacts, :sub_disposition, :string
  end

  def self.down
    remove_column :contacts, :disposition
    remove_column :contacts, :sub_disposition
  end
end
