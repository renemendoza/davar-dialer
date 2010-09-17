class Session < Authlogic::Session::Base
  authenticate_with Agent
end
