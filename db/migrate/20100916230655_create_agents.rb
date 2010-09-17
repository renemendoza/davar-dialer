class CreateAgents < ActiveRecord::Migration
  def self.up
    create_table :agents do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :ring_to_destination
      t.string :language_settings

      t.timestamps
    end
  end

  def self.down
    drop_table :agents
  end
end
