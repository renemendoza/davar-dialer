class AddAutomaticDialSwitchToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :automatic_dialer, :boolean
  end

  def self.down
    remove_column :agents, :automatic_dialer
  end
end
