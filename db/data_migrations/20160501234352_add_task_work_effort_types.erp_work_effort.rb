# This migration comes from erp_work_effort (originally 20131215225329)
class AddTaskWorkEffortTypes
  
  def self.up
    WorkEffortType.create(description: 'Ticket', internal_identifier: 'ticket')
  end
  
  def self.down
    WorkEffortType.find_by_internal_identifier('ticket').destroy
  end

end
