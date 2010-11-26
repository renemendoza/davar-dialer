initialization do
  Semaphore = Mutex.new
#  ActiveRecord::Base.verify_active_connections!

#  parser = Object.new
#  parser.extend EventsParse

#  Events.register_callback([:asterisk, :manager_interface]) do |event|
#    case event.name.downcase
#    when  /originateresponse/
#      parser.originate_response(event.headers)
#    when  /link/
#      parser.link(event.headers)
#    when  /bridge/
#      parser.link(event.headers)
#    when  /hangup/
#      parser.hangup(event.headers)
#    end
#  end
end


#module EventsParse
methods_for :events do
  def originate_response(e)
    Semaphore.synchronize {
      AutoCall.process_originate_response(e["ActionID"], e["Reason"], e["Uniqueid"])   
    }
    #resp_codes = Agent::ResponseCodes
    #ahn_log "OriginateResponse: #{e.inspect}"
    #begin
    #  c = AutoCall.find_by_action_id(e["ActionID"])
    #  c.result_leg_a = resp_codes.include?(e["Reason"]) ? resp_codes[e["Reason"]] : "other_#{e['Reason']}"
    #  c.unique_id_a = e["Uniqueid"]    
    #  if c.result_leg_a == "answered"
    #    c.leg_a_answered_at = Time.now
    #  end
    #  c.save
    #rescue => err
    #  ahn_log "Not found by actionid   #{err.message}"
    #  ahn_log err
    #end
  end


  def hangup(e)
    #ahn_log "Hangup: #{e.inspect}"
    Semaphore.synchronize {
      AutoCall.process_hangup(e["Uniqueid"])   
    }
  end

  def link(e)
    #ahn_log "Link: #{e.inspect}"
    Semaphore.synchronize {
      AutoCall.process_link(e["Uniqueid1"], e["Uniqueid2"])
    }
  end

  def cdr(e)
    ahn_log "Link: #{e.inspect}"
    Semaphore.synchronize {
      AutoCall.process_cdr(e["UniqueID"], e["Duration"], e["BillableSeconds"])   
    }
  end

    #when /cdr/
     # there are some durations but they might be worthless
     # ahn_log "#{event.inspect}"
   # end   
end


methods_for :dialplan do

  def process_inbound_dialer
    call  = AutoCall.find(variable('auto_call_id'))
    
    dial call.dial_string, :for => 30.seconds, :caller_id => call.phone_number, :name => call.contact.name
    call.result_leg_b = last_dial_status.to_s
    call.save!

    #:answer, :busy, :no_answer, :cancelled, :congested, and :channel_unavailable. If :cancel is returned, the caller hung up before the callee picked up. If :congestion is returned, the dialed extension probably doesn’t exist. If :channel_unavailable, the callee phone may not be registered. 

  end

end


