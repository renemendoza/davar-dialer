module Telephony

  def dial(contact)
    simple_dial(contact)

    #use a flag to choose between simple_dial and dial with amd
    #else
    #amd_dial(contact)
  end

  def simple_dial(contact)
    number_to = contact.phone_number_1   #hmm smells like coupling?
    number_from = ring_to_destination

    context=APP_CONFIG[:simple_dial_context]
    
    
    channel = "Local/#{number_to}@#{context}/n"
      
    #this will return the result and we need tests for this
    AHN.originate({
        :channel   => channel,    #the remote
        :context   => context,    #the local
        :exten   => number_from, 
        :priority  => 1,
        :callerid  => number_to,
        :async => 'true' })
  end

  def amd_dial(contact)
    context=APP_CONFIG[:amd_dial_context]
    #this is harder
  end


end
  #irb(main):010:0> res.headers
  #=> {"Message"=>"Originate successfully queued", "ActionID"=>"XqdqhZZq-8O5V-A9IP-wjAI-RdRnCRmPK8PS"}

