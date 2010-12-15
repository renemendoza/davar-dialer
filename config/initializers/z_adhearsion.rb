require "drb"
require 'adhearsion/voip/asterisk/manager_interface'
AHN = DRbObject.new_with_uri APP_CONFIG[:ahn_url]
require "telephony"

