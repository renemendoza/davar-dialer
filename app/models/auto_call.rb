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
    #lets just process the CDR event for this one
    if leg_a_answered_at.nil?
      return 0
    else
      if hangup? 
        (leg_a_hangup_at - leg_a_answered_at).round
      else
        (Time.now - leg_a_answered_at).round
      end
    #  if hangup_at.nil? 
    #    (Time.now - leg_a_answered_at).round
    #  else
    #    (hangup_at - leg_a_answered_at).round
    #  end
    end
  end

  def agent_delay
    unless leg_a_answered_at.nil? || leg_b_answered_at.nil?
      (leg_b_answered_at - leg_a_answered_at).round
    else
      return 0
    end
  end


  def hangup?
    return false if leg_a_hangup_at.nil? || leg_b_hangup_at.nil?   
    return true
  end


  def self.process_hangup(unique_id)
    if ac = AutoCall.where( ["unique_id_a = ? OR unique_id_b = ?", unique_id, unique_id ] ).first
      if ac.unique_id_a == unique_id
        ac.leg_a_hangup_at = Time.now
        ac.hangup_by ||= :contact
      elsif ac.unique_id_b = unique_id
        ac.leg_b_hangup_at = Time.now
        ac.hangup_by ||= :agent
      end
      ac.save
    end
  end

  def self.process_link(uid_a, uid_b)
    #h  angup(e["Uniqueid"])   
    if ac = AutoCall.find_by_unique_id_a(uid_a)
      if ac.unique_id_b.nil? and ac.leg_b_answered_at.nil?
        ac.unique_id_b = uid_b
        ac.leg_b_answered_at = Time.now
        ac.save
      end
    end
  end


end
