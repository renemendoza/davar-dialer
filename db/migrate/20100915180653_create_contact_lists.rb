class CreateContactLists < ActiveRecord::Migration
  def self.up
    create_table :contact_lists do |t|
      t.integer :owner_id
      t.string :list_file_name
      t.string :list_content_type
      t.integer :list_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_lists
  end
end
