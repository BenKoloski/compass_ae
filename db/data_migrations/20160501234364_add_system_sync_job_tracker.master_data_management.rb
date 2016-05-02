# This migration comes from master_data_management (originally 20150211010342)
class AddSystemSyncJobTracker
  
  def self.up
      JobTracker.create(
          :job_name => 'External Systems Sync',
          :job_klass => 'MasterDataManagement::DelayedJobs::ExternalSystemsSyncJob'
      )
  end
  
  def self.down
    JobTracker.find_by_job_klass('MasterDataManagement::DelayedJobs::ExternalSystemsSyncJob').destroy
  end

end
