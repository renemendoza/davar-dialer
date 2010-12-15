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
    #ahn_log "OriginateResponse: #{e.inspect}"
    #Semaphore.synchronize {
      AutoCall.process_originate_response(e["ActionID"], e["Reason"], e["Uniqueid"])   
    #}
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
    #ahn_log "CDR: #{e.inspect}"
    Semaphore.synchronize {
      AutoCall.process_cdr(e["UniqueID"], e["Duration"], e["BillableSeconds"])   
    }
  end

end

methods_for :rpc do

  def originate_queue(opts)
    return Adhearsion::VoIP::Asterisk.manager_interface.originate(opts).headers["ActionID"] 
    #or return error
  end

end

methods_for :dialplan do

  def process_inbound_dialer
    ac  = AutoCall.find(variable('auto_call_id'))
    
    dial ac.dial_string, :for => 30.seconds, :caller_id => ac.phone_number, :name => ac.contact.name
    ac.result_leg_b = last_dial_status.to_s
    if ac.result_leg_b != "answered"
      ac.error = ac.result_leg_b
      #ac.agent_failed_to_answer!
      ac.state = "finished_with_error"
    end
    ac.save!

    #:answer, :busy, :no_answer, :cancelled, :congested, and :channel_unavailable. If :cancel is returned, the caller hung up before the callee picked up. If :congestion is returned, the dialed extension probably doesn’t exist. If :channel_unavailable, the callee phone may not be registered. 

  end

end


