class AddTrunkFieldToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :trunk, :string
  end

  def self.down
    remove_column :agents, :trunk
  end
end
