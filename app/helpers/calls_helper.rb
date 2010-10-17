module CallsHelper
  def format_durations(s)
    Time.at(s).gmtime.strftime('%M:%S')
  end

  def agent_leg_result(c)
    if c.result_leg_b.nil?
      unless c.leg_b_answered_at.nil?
        "answered"
      else
        nil
      end
    else
      c.result_leg_b
    end
  end
end
