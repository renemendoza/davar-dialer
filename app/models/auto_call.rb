class AutoCall < ActiveRecord::Base
  belongs_to :agent
  belongs_to :contact


  def dial_string
    dialer_trunk =APP_CONFIG[:dialer_trunk]
    unless agent.trunk.nil?
      return "#{agent.trunk}/#{agent.ring_to_destination}"
    else
      return "#{dialer_trunk}/#{agent.ring_to_destination}"
    end
  end
end
