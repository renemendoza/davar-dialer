class AddStreetAddressCityStateResortToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :street_address, :string
    add_column :contacts, :city, :string
    add_column :contacts, :state, :string
    add_column :contacts, :resort, :string
  end

  def self.down
    remove_column :contacts, :street_address
    remove_column :contacts, :city
    remove_column :contacts, :state
    remove_column :contacts, :resort
  end
end
