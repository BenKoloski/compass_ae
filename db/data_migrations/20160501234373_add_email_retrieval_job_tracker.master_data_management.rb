# This migration comes from master_data_management (originally 20160301064555)
class AddEmailRetrievalJobTracker

  def self.up
    JobTracker.create(
        :job_name => 'Email Retrieval Job',
        :job_klass => 'MasterDataManagement::DelayedJobs::EmailRetrievalJob'
    )

  end

  def self.down
    JobTracker.find_by_job_klass('MasterDataManagement::DelayedJobs::EmailRetrievalJob').destroy
  end

end
