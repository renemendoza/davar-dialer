
nitialization do
  resp_codes = Telephony::ResponseCodes
  dialer_trunk =APP_CONFIG[:dialer_trunk]

  Events.register_callback "/asterisk/manager_interface" do |event|
    case event.name.downcase

    when  /originateresponse/

      e = event.headers
      ahn_log "OriginateResponse: #{e.inspect}"
      c = AutoCall.find_by_action_id(e["ActionID"])

      c.result_leg_a = resp_codes.include?(e["Reason"]) ? resp_codes[e["Reason"]] : "other_#{e['Reason']}"
      c.unique_id_a = e["Uniqueid"]    
      if c.result_leg_a == "answer"
        c.leg_a_answered_at = Time.now
      end
      c.save

    when "link"
      e = event.headers
      ahn_log "Link: #{e.inspect}"
      call = AutoCall.find_by_unique_id_a(e["Uniqueid1"])
      call.unique_id_b = e["Uniqueid2"]
      call.leg_b_answered_at = Time.now
      call.save!

    when "unlink"
      e = event.headers
      ahn_log "Unlink: #{e.inspect}"
      call = AutoCall.find_by_unique_id_a(e["Uniqueid1"])
      call.hangup_at = Time.now
      call.save!

    #when  /hangup/
      #ahn_log "#{event.inspect}"
      #there are two hangup events which is first?

    #when /cdr/
     #e = event.headers
     # call = AutoCall.find_by_unique_id_a(e["Uniqueid1"])
     # there are some durations but they might be worthless
     # ahn_log "#{event.inspect}"
    end   
  end

end

methods_for :dialplan do

  def process_inbound_dialer
    #begin
    call  = AutoCall.find(variable('auto_call_id'))
    #rescue
    #end
    
    dial call.dial_string, :for => 30.seconds, :caller_id => call.phone_number, :name => call.contact.name
    call.result_leg_b = last_dial_status.to_s
    call.save!
    ActiveRecord::Base.connection_pool.release_connection

    #:answer, :busy, :no_answer, :cancelled, :congested, and :channel_unavailable. If :cancel is returned, the caller hung up before the callee picked up. If :congestion is returned, the dialed extension probably doesn’t exist. If :channel_unavailable, the callee phone may not be registered. 

  end

end


