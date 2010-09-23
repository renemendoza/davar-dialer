class AddLoginCountLoginDatetimeAndLoginIpColumnsToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :login_count, :integer, :default => 0
    add_column :agents, :last_request_at, :datetime
    add_column :agents, :last_login_at, :datetime
    add_column :agents, :current_login_at, :datetime
    add_column :agents, :current_login_ip, :string
    add_column :agents, :last_login_ip, :string
  end

  def self.down
  end
end
