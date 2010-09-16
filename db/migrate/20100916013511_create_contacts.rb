class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.string :phone_number_1
      t.integer :contact_list_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
