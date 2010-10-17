class AutoCall < ActiveRecord::Base
  belongs_to :agent
  belongs_to :contact, :counter_cache => true



  def dial_string
    dialer_trunk =APP_CONFIG[:dialer_trunk]
    unless agent.trunk.nil? || agent.trunk.blank?
      return "#{agent.trunk}/#{agent.ring_to_destination}"
    else
      return "#{dialer_trunk}/#{agent.ring_to_destination}"
    end
  end

  def duration
    if leg_a_answered_at.nil?
      return 0
    else
      if hangup_at.nil? 
        (Time.now - leg_a_answered_at).round
      else
        (hangup_at - leg_a_answered_at).round
      end
    end
  end

  def agent_delay
    unless leg_a_answered_at.nil? || leg_b_answered_at.nil?
      (leg_b_answered_at - leg_a_answered_at).round
    else
      return 0
    end
  end


  def self.find_by_any_unique_id(unique_id)
    AutoCall.where( ["unique_id_a = ? OR unique_id_b = ?", unique_id, unique_id ] ).first
  end

  def hang_up_event_owner(unique_id)
    if unique_id_a == unique_id
      return :contact
    else
      return :agent
    end
  end

  def determine_who_hangup!(unique_id)
    if self.hangup_at.nil? && self.hangup_by.nil?   #this call has not received a single hangup event
      self.hangup_at = Time.now
      self.hangup_by = hang_up_event_owner(unique_id)
      self.save
    end
  end
end
