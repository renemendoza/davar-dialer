class ScheduledTask < ActiveRecord::Base
  belongs_to :agent
  belongs_to :contact
end
