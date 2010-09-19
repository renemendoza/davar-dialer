#require "drb"
#require "adhearsion"
require 'adhearsion/voip/asterisk/manager_interface'
require "telephony"
AHN = DRbObject.new_with_uri APP_CONFIG[:ahn_url]

