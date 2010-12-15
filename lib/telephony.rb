module Telephony


  class TelephonyError < RuntimeError
  end

  #ami
  ResponseCodes =  {
    "0" => "do_not_exist",
    "1" => "no_answer",
    "3" => "ringing_no_answer",
    "4" => "answered",
    "5" => "busy",
    "8" => "congested"
  }  


  def dial(contact)

    begin
      if use_amd?
        #amd_dial(contact)
        simple_dial(contact)
      else
        simple_dial(contact)
      end


    rescue StandardError => ex
      if ex.is_a? DRb::DRbConnError
        raise TelephonyError, "Connection to Adhearsion via DRb failed:  #{ex.message}"
      else
        raise TelephonyError, "An error has ocurred:  #{ex.message}  "
      end
    end

  end



  def simple_dial(contact)
    number_to = contact.phone_number_1   #hmm smells like coupling?

    trunk=APP_CONFIG[:dialer_trunk]
    context=APP_CONFIG[:dialer_context]
    prefix=APP_CONFIG[:default_prefix]

  

    channel = "#{trunk}/#{prefix}#{number_to}"  
    auto_call = contact.auto_calls.build({:contact_id => contact.id, :agent_id => self.id, :phone_number => number_to})

    auto_call.save #maybe this is redundant?
    agi_url = "agi://127.0.0.1/" + context   #maybe we dont want to hardcode the URL 

    action_id = AHN.originate_queue({
          :channel   => channel,    #the remote
          :application   => "AGI",  #local leg  :)
          :data => agi_url,
          :callerid  => number_to,
          :timeout => 30000,
          :variable => "auto_call_id=#{auto_call.id}",
          :async => 'true' })

    #check the action_id and raise an error if necessary
    auto_call.action_id = action_id
    #auto_call.dialing_remote_end!
    auto_call.state = "originate_attempt"
    auto_call.save
    auto_call
  end

#sandwich code example lets refactor
  
  def amd_dial(contact)
    context=APP_CONFIG[:amd_dial_context]
    #this is harder
  end


end

