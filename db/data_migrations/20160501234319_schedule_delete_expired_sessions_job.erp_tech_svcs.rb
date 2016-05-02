# This migration comes from erp_tech_svcs (originally 20110802200222)
class ScheduleDeleteExpiredSessionsJob
  
  def self.up
    ErpTechSvcs::DelayedJobs::DeleteExpiredSessionsJob.schedule_job(Time.now)
  end
  
  def self.down
    #remove data here
  end

end
