class AddAdminColumnToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :admin, :boolean
  end

  def self.down
    remove_column :agents, :admin
  end
end
