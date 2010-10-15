class AddUseAmdSwitchToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :use_amd, :boolean
  end

  def self.down
    remove_column :agents, :use_amd, :boolean
  end
end
