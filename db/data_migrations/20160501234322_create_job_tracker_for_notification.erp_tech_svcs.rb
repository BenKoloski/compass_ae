# This migration comes from erp_tech_svcs (originally 20150819140550)
class CreateJobTrackerForNotification
  
  def self.up
    JobTracker.create(
        :job_name => 'Notification Job',
        :job_klass => 'ErpTechSvcs::DelayedJobs::NotificationJob'
    )
  end
  
  def self.down
    JobTracker.find_by_job_name('Notification Job').destroy
  end

end
